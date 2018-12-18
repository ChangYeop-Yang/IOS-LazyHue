# ■ LazyHUE - iOS Application <kbd>**MOBILE - iOS**</kbd>

<p align="center">
 <img src="https://user-images.githubusercontent.com/20036523/49021283-a1391180-f1d5-11e8-976d-a0d1bd010667.png" width="400" height="400" />
</p>

## ★ Outline

###### ※ Implemented features

* 공공데이터(Open Data)를 활용한 오늘의 날씨 기능 제공 [Temperature, Humidity, Ozone, Visible Distance, Fine Dust]
* Arduino의 센서를 활용한 데이터 제공 
* LBS(Location Based Service)를 활용 한 주소(Road Name Address) 정보 제공
* RGB 조절을 통한 전체 Philips Hue 색깔 변경 기능 제공
* Motion 기능을 통한 Philips Hue 전원 관리 기능 제공
* 사진속의 색상을 통해 Philips Hue 색상 변경 기능 제공
* 카메라을 사용하여 Real-Time으로 풍경을 통한 Philips Hue 색상 변경 기능 제공
* Core ML의 MNIST 모델을 활용 한 손글씨 기반의 제스처 기능 제공 [숫자에 맞는 색상 변경 및 전원 관리]

###### ※ Used Technology

:wrench: [Metarial Design](https://material.io/design/)

:wrench: [Philips Hue API](https://developers.meethue.com/)

:wrench: [Core Data - Apple Framework](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075-CH2-SW1)

:wrench: [Core ML - Apple Framework](https://developer.apple.com/documentation/coreml)

:wrench: [LBS (Location Based Service)](https://ko.wikipedia.org/wiki/%EC%9C%84%EC%B9%98_%EA%B8%B0%EB%B0%98_%EC%84%9C%EB%B9%84%EC%8A%A4)

:wrench: [Google Sign - In into Your iOS App API](https://developers.google.com/identity/sign-in/ios/)

:wrench: [Naver Cloud Platform - Micro Server & DNS](https://www.ncloud.com/)

###### ※ Used Arduino Sensor

|Number|Model Name|Module Comment|
|:----:|:--------:|:------------:|
|001|Serial WIFI 모듈 (ESP-8266)|Serial을 통하여 WIFI 통신을 지원하는 모듈입니다.|
|002|가스 센서 (MQ-8)|일산화탄소 및 LPG가스의 농도를 측정하는 센서입니다.|
|003|CDS 센서 (GL-5516)|주변 환경으로부터 조도(Lux)를 측정하는 센서입니다.|
|004|3색 LED 센서 (3-Color RGB SMD LED Module)|3색 LED를 발광하는 센서입니다.|
|005|충격 센서 (WAT-S023)|주변 환경으로부터 충격을 감지하는 센서입니다.|

* * *

![](https://user-images.githubusercontent.com/20036523/50043777-af37cf00-00bd-11e9-8cbf-7eaf62ed2048.JPG)

## ★ Development Environment for Application

:hammer: macOS Mojave Version 10.14.1

:hammer: XCODE Version 10.1

:hammer: Swift Version 4.2

:hammer: Github Desktop Version 1.4.3

:hammer: QuickTime Player Version 10.5

## ★ Application UI/UX

|:camera: CONNECT DISPLAY IMAGE 001|:camera: CONNECT DISPLAY IMAGE 002|
|:--------------------------------:|:--------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/49296163-d9ed2980-f4fa-11e8-960f-fc431621cc16.png)|![](https://user-images.githubusercontent.com/20036523/49296162-d9ed2980-f4fa-11e8-95cc-ea5a7f80a5cf.png)|

|:camera: HOME DISPLAY IMAGE 001|:camera: HOME DISPLAY IMAGE 002|
|:-----------------------------:|:-----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/49284504-24a97a00-f4d8-11e8-8052-aee64db3858b.png)|![](https://user-images.githubusercontent.com/20036523/49328764-239c4980-f5b9-11e8-88c6-03df8404061c.png)|

|:camera: CAMERA DISPLAY IMAGE 001|:camera: CAMERA DISPLAY IMAGE 002|
|:-------------------------------:|:-------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/49280603-f32bb100-f4cd-11e8-8409-c9dec149104f.png)|![](https://user-images.githubusercontent.com/20036523/49280604-f3c44780-f4cd-11e8-8e36-19fa1179acb7.png)|

|:camera: DETAIL DISPLAY IMAGE 001|:camera: DETAIL DISPLAY IMAGE 002|
|:-------------------------------:|:-------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/49687986-bf482f80-fb4e-11e8-891d-8448be08203f.png)|![](https://user-images.githubusercontent.com/20036523/49748304-a96e7200-fce8-11e8-9a04-56c388fbdf58.png)|

|:camera: GESTURE DISPLAY IMAGE 001|:camera: GESTURE DISPLAY IMAGE 002|
|:--------------------------------:|:--------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/49280615-fde64600-f4cd-11e8-99a9-642ee3292cd9.png)|![](https://user-images.githubusercontent.com/20036523/49280617-fde64600-f4cd-11e8-94df-f7779713679e.png)|

|:camera: SETTING DISPLAY IMAGE 001|:camera: SETTING DISPLAY IMAGE 002|
|:--------------------------------:|:--------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/49280626-0474bd80-f4ce-11e8-83f4-e2e3a46a8cfd.png)|![](https://user-images.githubusercontent.com/20036523/49328835-2fd4d680-f5ba-11e8-85b6-8f340469d2a9.png)|

## ★ Application Method of use

|:camera: CONNECT application Method of use|
|:----------------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043779-af37cf00-00bd-11e9-8f37-dc3d29a076c0.JPG)|

|:camera: HOME application Method of use|
|:-------------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043778-af37cf00-00bd-11e9-9a53-4180b80f8c09.JPG)|

|:camera: CAMERA application Method of use|
|:---------------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043780-afd06580-00bd-11e9-9d47-bb277f3deae4.JPG)|

|:camera: DETAIL application Method of use|
|:---------------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043781-afd06580-00bd-11e9-998d-fafdbde0a9c2.JPG)|

|:camera: GESTURE application Method of use|
|:----------------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043782-afd06580-00bd-11e9-9562-fae842124002.JPG)|

|:camera: SETTING application Method of use|
|:----------------------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043783-afd06580-00bd-11e9-94c0-7d643d4a6ade.JPG)|

## ★ Demo Play

|:movie_camera: Demo Play for Application|
|:--------------------------------------:|
|<div align="center"><a href="https://www.youtube.com/watch?v=JPzTv8qNuvM"><img src="https://img.youtube.com/vi/JPzTv8qNuvM/0.jpg" width="1024" height="486"></a></div>|

|:video_camera: Detail Demo Play 001|:video_camera: Detail Demo Play 002|
|:---------------------------------:|:---------------------------------:|
|<img src="https://user-images.githubusercontent.com/20036523/50155267-05e81780-030f-11e9-9666-42346e308bf2.gif" width="720" />|<img src="https://user-images.githubusercontent.com/20036523/50155268-0680ae00-030f-11e9-8487-d16ddb2a5810.gif" width="720" />|

|:video_camera: Detail Demo Play 003|:video_camera: Detail Demo Play 004|
|:---------------------------------:|:---------------------------------:|
|<img src="https://user-images.githubusercontent.com/20036523/50155269-0680ae00-030f-11e9-81b4-310918fad564.gif" width="720" />|<img src="https://user-images.githubusercontent.com/20036523/50155271-07194480-030f-11e9-9dc1-975923ac3acd.gif" width="720" />|

|:video_camera: Detail Demo Play 005|:video_camera: Detail Demo Play 006|
|:---------------------------------:|:---------------------------------:|
|<img src="https://user-images.githubusercontent.com/20036523/50155272-07194480-030f-11e9-9d5a-d2062e970e9f.gif" width="720" />|<img src="https://user-images.githubusercontent.com/20036523/50155264-054f8100-030f-11e9-83b3-78d51073e0ab.gif" width="720" />|

## ★ Reference URL

:airplane: [Styles Vision - Github](https://github.com/cocoa-ai/StylesVisionDemo)

:airplane: [Google Sign-In Quickstart - Github](https://github.com/googlesamples/google-services/tree/master/ios/signin)

:airplane: [CoreMLHandwritingRecognition - Github](https://github.com/brianadvent/CoreMLHandwritingRecognition)
 
## ★ Open Source List

:airplane: [Gloss - OpenSource](https://github.com/hkellaway/Gloss)

:airplane: [Dark Sky - OpenSource](https://darksky.net/dev)

:airplane: [SwiftyHue - OpenSource](https://github.com/Spriter/SwiftyHue)

:airplane: [Alamofire - OpenSource](https://github.com/Alamofire/Alamofire)

:airplane: [SwiftSpinner - OpenSource](https://github.com/icanzilb/SwiftSpinner)

:airplane: [Google Sign-In for iOS - Google API](https://developers.google.com/identity/sign-in/ios/)

## ★ Developer Information

|:rocket: Github QR Code|:pencil: Naver-Blog QR Code|:eyeglasses: Linked-In QR Code|
|:---------------------:|:-------------------------:|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50044128-60406880-00c2-11e9-8d57-ea1cb8e6b2a7.jpg)|![](https://user-images.githubusercontent.com/20036523/50044131-60d8ff00-00c2-11e9-818c-cf5ad97dc76e.jpg)|![](https://user-images.githubusercontent.com/20036523/50044130-60d8ff00-00c2-11e9-991a-107bffa2bf57.jpg)|
