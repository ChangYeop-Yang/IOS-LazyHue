//
//  LocationMethods.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 7..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import CoreLocation

// MARK: - Structure
private struct lamc_parameter
{
    var Re:Float    /* 사용할 지구반경 [Km]    */
    var grid:Float  /* 격자간격 [Km]        */
    var slat1:Float /* 표준위도 [Degree] */
    var slat2:Float /* 표준위도 [Degree] */
    var olon:Float  /* 기준점의 경도 [Degree] */
    var olat:Float  /* 기준점의 위도 [Degree] */
    var xo:Float    /* 기준점의 X좌표 [격자거리] */
    var yo:Float    /* 기준점의 Y좌표 [격자거리] */
    
    init()
    {
        self.Re    = 6371.00877         // 지도반경
        self.grid  = 5.0                // 격자간격 (km)
        self.slat1 = 30.0               // 표준위도 1
        self.slat2 = 60.0               // 표준위도 2
        self.olon  = 126.0              // 기준점 경도
        self.olat  = 38.0               // 기준점 위도
        self.xo    = 210/self.grid      // 기준점 X좌표
        self.yo    = 675/self.grid      // 기준점 Y좌표
    }
}

// MARK: - Method
public func convertGridXY(location: CLLocation) -> (nx: Int, ny: Int) {
    
    var PI:Double, DEGRAD:Double
    var re:Double, olon:Double, olat:Double, sn:Double, sf:Double, ro:Double
    var slat1:Double, slat2:Double, ra:Double, theta:Double
    let map: lamc_parameter = lamc_parameter()
    
    PI = asin(1.0) * 2.0
    DEGRAD = PI / 180.0
    
    re = Double(map.Re / map.grid)
    slat1 = Double(map.slat1) * DEGRAD
    slat2 = Double(map.slat2) * DEGRAD
    olon = Double(map.olon) * DEGRAD
    olat = Double(map.olat) * DEGRAD
    
    sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
    sn = log(cos(slat1) / cos(slat2)) / log(sn)
    sf = tan(PI * 0.25 + slat1 * 0.5)
    sf = pow(sf, sn) * cos(slat1) / sn
    ro = tan(PI * 0.25 + olat * 0.5)
    ro = re * sf / pow(ro, sn)
    
    ra = tan(PI * 0.25 + location.coordinate.latitude * DEGRAD * 0.5)
    ra = re * sf / pow(ra, sn)
    theta = location.coordinate.longitude * DEGRAD - olon
    
    if theta > PI   { theta -= 2.0 * PI }
    if theta < -PI  { theta += 2.0 * PI }
    theta *= sn
    
    let x = Float(ra * sin(theta)) + map.xo
    let y = Float(ro - ra * cos(theta)) + map.yo
    
    return (Int(x + 1.5), Int(y + 1.5))
}
