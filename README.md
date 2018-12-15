# ■ LazyHUE - iOS Application

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

* [Metarial Design](https://material.io/design/)
* [Philips Hue API](https://developers.meethue.com/)
* [Core Data - Apple Framework](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075-CH2-SW1)
* [Core ML - Apple Framework](https://developer.apple.com/documentation/coreml)
* [LBS (Location Based Service)](https://ko.wikipedia.org/wiki/%EC%9C%84%EC%B9%98_%EA%B8%B0%EB%B0%98_%EC%84%9C%EB%B9%84%EC%8A%A4)
* [Google Sign - In into Your iOS App API](https://developers.google.com/identity/sign-in/ios/)
* [Naver Cloud Platform - Micro Server & DNS](https://www.ncloud.com/)

###### ※ Used Arduino Sensor

|Number|Model Name|Module Comment|
|:----:|:--------:|:------------:|
|001|Serial WIFI 모듈 (ESP-8266)|Serial을 통하여 WIFI 통신을 지원하는 모듈입니다.|
|002|가스 센서 (MQ-8)|일산화탄소 및 LPG가스의 농도를 측정하는 센서입니다.|
|003|CDS 센서 (GL-5516)|주변 환경으로부터 조도(Lux)를 측정하는 센서입니다.|
|004|3색 LED 센서 (3-Color RGB SMD LED Module)|3색 LED를 발광하는 센서입니다.|
|005|충격 센서 (WAT-S023)|주변 환경으로부터 충격을 감지하는 센서입니다.|

## ★ Application UI/UX

|CONNECT DISPLAY IMAGE 001|CONNECT DISPLAY IMAGE 002|
|:---------------:|:---------------:|
|![](https://user-images.githubusercontent.com/20036523/49296163-d9ed2980-f4fa-11e8-960f-fc431621cc16.png)|![](https://user-images.githubusercontent.com/20036523/49296162-d9ed2980-f4fa-11e8-95cc-ea5a7f80a5cf.png)|

* * *

|HOME DISPLAY IMAGE 001|HOME DISPLAY IMAGE 002|
|:------------:|:------------:|
|![](https://user-images.githubusercontent.com/20036523/49284504-24a97a00-f4d8-11e8-8052-aee64db3858b.png)|![](https://user-images.githubusercontent.com/20036523/49328764-239c4980-f5b9-11e8-88c6-03df8404061c.png)|

* * *

|CAMERA DISPLAY IMAGE 001|CAMERA DISPLAY IMAGE 002|
|:----------------------:|:----------------------:|
|![](https://user-images.githubusercontent.com/20036523/49280603-f32bb100-f4cd-11e8-8409-c9dec149104f.png)|![](https://user-images.githubusercontent.com/20036523/49280604-f3c44780-f4cd-11e8-8e36-19fa1179acb7.png)|

* * *

|DETAIL DISPLAY IMAGE 001|DETAIL DISPLAY IMAGE 002|
|:----------------------:|:----------------------:|
|![](https://user-images.githubusercontent.com/20036523/49687986-bf482f80-fb4e-11e8-891d-8448be08203f.png)|![](https://user-images.githubusercontent.com/20036523/49748304-a96e7200-fce8-11e8-9a04-56c388fbdf58.png)|

* * *

|GESTURE DISPLAY IMAGE 001|GESTURE DISPLAY IMAGE 002|
|:---------------:|:---------------:|
|![](https://user-images.githubusercontent.com/20036523/49280615-fde64600-f4cd-11e8-99a9-642ee3292cd9.png)|![](https://user-images.githubusercontent.com/20036523/49280617-fde64600-f4cd-11e8-94df-f7779713679e.png)|

* * *

|SETTING DISPLAY IMAGE 001|SETTING DISPLAY IMAGE 002|
|:------------:|:------------:|
|![](https://user-images.githubusercontent.com/20036523/49280626-0474bd80-f4ce-11e8-83f4-e2e3a46a8cfd.png)|![](https://user-images.githubusercontent.com/20036523/49328835-2fd4d680-f5ba-11e8-85b6-8f340469d2a9.png)|

## ★ Application Method of use

|CONNECT application Method of use|
|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043779-af37cf00-00bd-11e9-8f37-dc3d29a076c0.JPG)|

* * *

|HOME application Method of use|
|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043778-af37cf00-00bd-11e9-9a53-4180b80f8c09.JPG)|

* * *

|CAMERA application Method of use|
|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043780-afd06580-00bd-11e9-9d47-bb277f3deae4.JPG)|

* * *

|DETAIL application Method of use|
|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043781-afd06580-00bd-11e9-998d-fafdbde0a9c2.JPG)|

* * *

|GESTURE application Method of use|
|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043782-afd06580-00bd-11e9-9562-fae842124002.JPG)|

* * *

|SETTING application Method of use|
|:----------------------------:|
|![](https://user-images.githubusercontent.com/20036523/50043783-afd06580-00bd-11e9-94c0-7d643d4a6ade.JPG)|

## ★ Demo Play

## ★ Reference URL
* [Styles Vision - Github](https://github.com/cocoa-ai/StylesVisionDemo)
* [Google Sign-In Quickstart - Github](https://github.com/googlesamples/google-services/tree/master/ios/signin)
* [CoreMLHandwritingRecognition - Github](https://github.com/brianadvent/CoreMLHandwritingRecognition)
* [NativeScript Image Builder - iOS image assets](http://nsimage.brosteins.com/)
 
## ★ Open Source List 
* [Gloss - OpenSource](https://github.com/hkellaway/Gloss)
* [Dark Sky - OpenSource](https://darksky.net/dev)
* [SwiftyHue - OpenSource](https://github.com/Spriter/SwiftyHue)
* [Alamofire - OpenSource](https://github.com/Alamofire/Alamofire)
* [SwiftSpinner - OpenSource](https://github.com/icanzilb/SwiftSpinner)
* [Google Sign-In for iOS - Google API](https://developers.google.com/identity/sign-in/ios/)
