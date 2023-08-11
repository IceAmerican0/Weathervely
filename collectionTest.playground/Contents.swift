import UIKit

var greeting = "Hello, playground"


var timeArray = [ "0700", "1500", "2000" ]

var time = "2100"

for i in timeArray.indices {
    if time < timeArray[i] {
        
        timeArray.insert(time, at: i)
        
        for _ in 0..<i {
            timeArray.removeFirst()
        }

        break
    } else if time == timeArray[i] {
        timeArray.remove(at: i)
        timeArray.insert(time, at: i)
        for _ in 0..<i {
            timeArray.removeFirst()
        }
        break
    } else {
        if i == timeArray.count - 1 {
            timeArray.append(time)
            for _ in 0...i {
                timeArray.removeFirst()
            }
        } else {
            print("else")
            continue
        }
    }
}
print(timeArray)
