//
//  StaminaBarView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 5/8/24.
//

import Foundation
import SwiftUI

class StaminaBarView {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = true
    func stressFunction(heart_rate: CGFloat, hrv: CGFloat) -> AnyView {
        // if age > 35
        let baselineHRV: CGFloat = 65
        // baselineHRV: 0.45
        let adjustmentPerUnit: CGFloat = 0.5
        //  adjustmentPerUnit: 0.25
        let hrvAdjustment = -(max(baselineHRV - hrv, 0) * adjustmentPerUnit)
        var initalHeartRateMapping: String = ""
        var finalStaminaPercentage: CGFloat
        

        switch heart_rate {
            // MARK: Zone 1, Blue
        case -1..<1:
            initalHeartRateMapping = "Loading"
        case 1..<60:
            initalHeartRateMapping = "100"
        case 60..<64:
            initalHeartRateMapping = "99"
        case 64..<68:
            initalHeartRateMapping = "98"
        case 68..<72:
            initalHeartRateMapping = "97"
        case 72..<76:
            initalHeartRateMapping = "96"
        case 76..<80:
            initalHeartRateMapping = "95"
        case 80..<84:
            initalHeartRateMapping = "94"
        case 84..<88:
            initalHeartRateMapping = "93"
        case 88..<92:
            initalHeartRateMapping = "92"
        case 92..<96:
            initalHeartRateMapping = "91"
        case 96..<99:
            initalHeartRateMapping = "90"
            // MARK: Zone 2, Green
        case 99..<100:
            initalHeartRateMapping = "89"

        case 100..<104:
            initalHeartRateMapping = "88"
        case 104..<106:
            initalHeartRateMapping = "87"
        case 106..<108:
            initalHeartRateMapping = "86"
        case 108..<110:
            initalHeartRateMapping = "85"
        case 110..<112:
            initalHeartRateMapping = "84"
        case 112..<114:
            initalHeartRateMapping = "83"
        case 114..<116:
            initalHeartRateMapping = "82"
        case 116..<120:
            initalHeartRateMapping = "81"
            // MARK: Zone 3, Yellow
        case (120)..<(121.4):
            initalHeartRateMapping = "80"
        case (121.4)..<(122.8):
            initalHeartRateMapping = "79"
        case (122.8)..<(124.8):
            initalHeartRateMapping = "78"
        case (124.8)..<(125.6):
            initalHeartRateMapping = "77"
        case (125.6)..<(127):
            initalHeartRateMapping = "76"
        case (127)..<(128.4):
            initalHeartRateMapping = "75"
        case (128.4)..<(129.8):
            initalHeartRateMapping = "74"
        case (129.8)..<(131.2):
            initalHeartRateMapping = "73"
        case (131.2)..<(132.6):
            initalHeartRateMapping = "72"
        case (132.6)..<(134):
            initalHeartRateMapping = "71"
        case (134)..<(135.4):
            initalHeartRateMapping = "70"
        case (135.4)..<(136.8):
            initalHeartRateMapping = "69"
        case (136.8)..<(138.2):
            initalHeartRateMapping = "68"
        case (138.2)..<(141):
            initalHeartRateMapping = "67"
        case (141)..<(142.4):
            initalHeartRateMapping = "66"
        case (142.4)..<(143.8):
            initalHeartRateMapping = "65"
        case (143.8)..<(145.2):
            initalHeartRateMapping = "64"
        case (145.2)..<(146.6):
            initalHeartRateMapping = "63"
        case (146.6)..<(148):
            initalHeartRateMapping = "62"
        case (148)..<(149.4):
            initalHeartRateMapping = "61"
        case (149.4)..<(150.8):
            
            initalHeartRateMapping = "60"
        case (150.8)..<(152.2):
            
            initalHeartRateMapping = "59"
        case (152.2)..<(153.6):
            initalHeartRateMapping = "58"
        case (153.6)..<(155):
            initalHeartRateMapping = "57"
        case (155)..<(156.4):
            initalHeartRateMapping = "56"
        case (156.4)..<(157.8):
            initalHeartRateMapping = "55"
        case (157.8)..<(159.2):
            initalHeartRateMapping = "54"
        case (159.2)..<(160.6):
            initalHeartRateMapping = "53"
        case (160.6)..<(162):
            initalHeartRateMapping = "52"
        case (162)..<(163.4):
            initalHeartRateMapping = "51"
            // MARK: Zone 4, Orange
        case (163.4)..<(164.1):
            initalHeartRateMapping = "50"
        case (164.1)..<(164.8):
            initalHeartRateMapping = "49"
        case (164.8)..<(165.5):
            initalHeartRateMapping = "48"
        case (165.5)..<(166.2):
            initalHeartRateMapping = "47"
        case (166.2)..<(166.9):
            initalHeartRateMapping = "46"
        case (166.9)..<(167.6):
            initalHeartRateMapping = "45"
        case (167.6)..<(168.3):
            initalHeartRateMapping = "44"
        case (168.3)..<(169.0):
            initalHeartRateMapping = "43"
        case (169.0)..<(169.7):
            initalHeartRateMapping = "42"
        case (169.7)..<(170.4):
       
            initalHeartRateMapping = "41"
        case (170.4)..<(171.1):
       
            initalHeartRateMapping = "40"
        case (171.1)..<(171.9):
            
            initalHeartRateMapping = "39"
        case (171.9)..<(172.5):
            initalHeartRateMapping = "38"
        case (172.5)..<(173.2):
            initalHeartRateMapping = "37"
        case (173.2)..<(173.9):
            initalHeartRateMapping = "36"
        case (173.9)..<(174.6):
            initalHeartRateMapping = "35"
        case (174.6)..<(175.3):
            initalHeartRateMapping = "34"
        case (175.3)..<(176.0):
            initalHeartRateMapping = "33"
        case (175.3)..<(176.0):
            initalHeartRateMapping = "32"
        case (176.0)..<(176.7):
     
            initalHeartRateMapping = "31"
        case (176.7)..<(177.4):
            initalHeartRateMapping = "30"
           
            // MARK: Zone 5, Red
        case (177.4)..<(178.4):
            initalHeartRateMapping = "29"
        case (178.4)..<(179.4):
            initalHeartRateMapping = "28"
        case (179.4)..<(180.4):
            initalHeartRateMapping = "27"
        case (180.4)..<(181.4):
            initalHeartRateMapping = "26"
        case (181.4)..<(182.4):
            initalHeartRateMapping = "25"
        case (182.4)..<(183.4):
            initalHeartRateMapping = "24"
        case (183.4)..<(184.4):
            initalHeartRateMapping = "23"
        case (184.4)..<(185.4):
            initalHeartRateMapping = "22"
        case (185.4)..<(186.4):
            initalHeartRateMapping = "21"
        case (186.4)..<(187.4):
            initalHeartRateMapping = "20"
        case (187.4)..<(188.4):
            initalHeartRateMapping = "19"
        case (188.4)..<(189.4):
            initalHeartRateMapping = "18"
        case (189.4)..<(190.4):
            initalHeartRateMapping = "17"
        case (190.4)..<(191.4):
            initalHeartRateMapping = "16"
        case (191.4)..<(192.4):
            initalHeartRateMapping = "15"
        case (192.4)..<(193.4):
            initalHeartRateMapping = "14"
        case (193.4)..<(194.4):
            initalHeartRateMapping = "13"
        case (194.4)..<(195.4):
            initalHeartRateMapping = "12"
        case (195.4)..<(196.4):
            initalHeartRateMapping = "11"
        case (196.4)..<(197.4):
            initalHeartRateMapping = "10"
        case (197.4)..<(198.4):
            initalHeartRateMapping = "9"
        case (198.4)..<(199.4):
            initalHeartRateMapping = "8"
        case (199.4)..<(200.4):
            initalHeartRateMapping = "7"
        case (200.4)..<(201.4):
            initalHeartRateMapping = "6"
        case (201.4)..<(202.4):
            initalHeartRateMapping = "5"
        case (202.4)..<(203.4):
            initalHeartRateMapping = "4"
        case (203.4)..<(204.4):
            initalHeartRateMapping = "3"
        case (204.4)..<(205.4):
            initalHeartRateMapping = "2"
        case (205.4)..<(206):
            initalHeartRateMapping = "1"
        default:
            return AnyView(Text("Invalid Value"))
        }
        
        // Convert initial stamina to a CGFloat for HRV calculation
            if let initialGenericMap = Float(initalHeartRateMapping) {
                finalStaminaPercentage = max(CGFloat(initialGenericMap) + hrvAdjustment, 0) 
            } else {
                return AnyView(ProgressView()) // Fallback in case of conversion failure
            }

            // Convert final stamina percentage back to string for image selection
        let finalStaminaString = String(format: "%.0f", finalStaminaPercentage)
        
        return AnyView(VStack(alignment: .leading) {
            Image(finalStaminaString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                
        })
        
    }
    
}
