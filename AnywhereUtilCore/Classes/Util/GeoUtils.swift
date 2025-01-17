//
//  GeoUtils.swift
//  vip
//
//  Created by chenghao guo on 2022/1/5.
//

import Foundation
import CoreLocation

public class GeoUtils {
    public static func distanceBetween(
        lat1: Double,
        lng1: Double,
        lat2: Double,
        lng2: Double
    ) -> Double {
        let dx = lng1 - lng2 // 经度差值
        let dy = lat1 - lat2 // 纬度差值
        let b = (lat1 + lat2) / 2.0 // 平均纬度
        let Lx = dx.toRadians() * 6367000.0 * cos(b.toRadians()) // 东西距离
        let Ly = 6367000.0 * dy.toRadians() // 南北距离
        return sqrt(Lx * Lx + Ly * Ly)  // 用平面的矩形对角距离公式计算总距离
    }

    /// - Parameters:
    ///   - point: 起始点
    ///   - distance: 起点和终点的距离
    ///   - angle: 方位角
    /// - Returns: 终点的经纬度
    static func pointFrom(point: CLLocationCoordinate2D, distance: Double, angle: Double) -> CLLocation {
        let lati1 = point.latitude
        let long1 = point.longitude

        let R = 6378137.0 // 球半径
        let sinLat = sin(lati1.toRadians())
        let cosLat = cos(lati1.toRadians())
        let cosDistR = cos(distance / R)
        let sinDistR = sin(distance / R)
        var lat2 = asin(sinLat * cosDistR + cosLat * sinDistR * cos(angle.toRadians()))
        var lon2 = long1.toRadians() + atan2(sin(angle.toRadians()) * sinDistR * cosLat, cosDistR - sinLat * sin(lat2))

        lon2 = lon2.toDegrees()
        lon2 = lon2 > 180 ? lon2 - 360 : lon2 < -180 ? lon2 + 360 : lon2
        lat2 = lat2.toDegrees()
        return CLLocation(latitude: lat2, longitude: lon2)
    }
}

extension Double {
    func toRadians() -> Double {
        return self * Double.pi / 180
    }

    func toDegrees() -> Double {
        return self * 180 / Double.pi
    }
}

extension CLLocationCoordinate2D {
    /// Returns the initial bearing from ‘this’ point to destination point.
    /// - Parameter point: Latitude/longitude of destination point.
    /// - Returns: Initial bearing in degrees from north (0°..360°).
    func initialBearing(to point: CLLocationCoordinate2D) -> Double {
        if latitude == point.latitude &&
            longitude == point.longitude {
            return Double.nan
        }

        let phi1 = latitude.toRadians()
        let phi2 = point.latitude.toRadians()
        let deltaLambda = (point.longitude - longitude).toRadians()

        let x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(deltaLambda)
        let y = sin(deltaLambda) * cos(phi2)
        let theta = atan2(y, x)

        let bearing = theta.toDegrees()

        return wrap360(degrees: bearing)
    }

    /// Returns the initial bearing from ‘this’ point to destination point.
    /// - Parameters:
    ///   - point: Latitude/longitude of destination point.
    ///   - trueHeading: The heading of the device
    /// - Returns: Initial bearing in degrees from the heading of the device (0°..360°).
    func relativeBearing(to point: CLLocationCoordinate2D, trueHeading: Double) -> Double {
        var bearing = initialBearing(to: point)
        if bearing.isNaN {
            return 0.0
        }

        if bearing >= trueHeading {
            bearing -= trueHeading
        } else {
            bearing = 360 - (trueHeading - bearing)
        }
        return bearing
    }

    /// Returns final bearing arriving at destination point from ‘this’ point; the final bearing will differ from the initial bearing by varying
    /// degrees according to distance and latitude.
    /// - Parameter point: Latitude/longitude of destination point.
    /// - Returns: Final bearing in degrees from north (0°..360°).
    func finalBearing(to point: CLLocationCoordinate2D) -> Double {
        let bearing = point.initialBearing(to: self) + 180
        return wrap360(degrees: bearing)
    }

    private func wrap360(degrees: Double) -> Double {
        if 0 <= degrees && degrees < 360 { return degrees } // avoid rounding due to arithmetic ops if within range

        // bearing wrapping requires a sawtooth wave function with a vertical offset equal to the
        // amplitude and a corresponding phase shift; this changes the general sawtooth wave function from
        //     f(x) = (2ax/p - p/2) % p - a
        // to
        //     f(x) = (2ax/p) % p
        // where a = amplitude, p = period, % = modulo; however, JavaScript '%' is a remainder operator
        // not a modulo operator - for modulo, replace 'x%n' with '((x%n)+n)%n'
        let x = degrees
        let a: Double = 180
        let p: Double = 360
        return (((2 * a * x / p).truncatingRemainder(dividingBy: p)) + p).truncatingRemainder(dividingBy: p)
    }
}
