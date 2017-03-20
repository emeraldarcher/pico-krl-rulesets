ruleset track_trips_2 {
  meta {
    name "Part 2 - Track Trips"
    description <<
Part 1 of lab
>>
    author "Kyle Cornelison"
    logging on
  }

  global {
    long_trip = 1000
  }
 
  rule process_trip {
    select when car new_trip
    pre { 
      attrs = event:attrs().klog("Attributes: ")
    }
    fired {
      raise explicit event "trip_processed"
        attributes attrs
    } 
  }
  
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      attrs = event:attrs().klog("Attributes: ")
      mileage = event:attr("mileage").klog("Passed in mileage: ")
    }
    if mileage <= long_trip
    then
      noop()
    fired {
      raise explicit event "found_long_trip"
        attributes attrs
    } 
  }

  rule found_long_trip {
    select when explicit found_long_trip
    pre {
      mileage = event.attrs("mileage").klog("Received mileage: ")
    }
    send_directive("trip") with
      long_trip = 1
  }

}
