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
    
    func stressFunction(heart_rate: CGFloat) -> AnyView {
        let staminaPercentage: String
        switch heart_rate {
            // MARK: Zone 1, Blue
        case -1..<1:
            staminaPercentage = "Loading"
        case 1..<60:
            staminaPercentage = "100"
        case 60..<64:
            staminaPercentage = "99"
        case 64..<68:
            staminaPercentage = "98"
        case 68..<72:
            staminaPercentage = "97"
        case 72..<76:
            staminaPercentage = "96"
        case 76..<80:
            staminaPercentage = "95"
        case 80..<84:
            staminaPercentage = "94"
        case 84..<88:
            staminaPercentage = "93"
        case 88..<92:
            staminaPercentage = "92"
        case 92..<96:
            staminaPercentage = "91"
        case 96..<99:
            staminaPercentage = "90"
            // MARK: Zone 2, Green
        case 99..<100:
            staminaPercentage = "89"

        case 100..<104:
            staminaPercentage = "88"
        case 104..<106:
            staminaPercentage = "87"
        case 106..<108:
            staminaPercentage = "86"
        case 108..<110:
            staminaPercentage = "85"
        case 110..<112:
            staminaPercentage = "84"
        case 112..<114:
            staminaPercentage = "83"
        case 114..<116:
            staminaPercentage = "82"
        case 116..<120:
            staminaPercentage = "81"
            // MARK: Zone 3, Yellow
        case (120)..<(121.4):
            staminaPercentage = "80"
        case (121.4)..<(122.8):
            staminaPercentage = "79"
        case (122.8)..<(124.8):
            staminaPercentage = "78"
        case (124.8)..<(125.6):
            staminaPercentage = "77"
        case (125.6)..<(127):
            staminaPercentage = "76"
        case (127)..<(128.4):
            staminaPercentage = "75"
        case (128.4)..<(129.8):
            staminaPercentage = "74"
        case (129.8)..<(131.2):
            staminaPercentage = "73"
        case (131.2)..<(132.6):
            staminaPercentage = "72"
        case (132.6)..<(134):
            staminaPercentage = "71"
        case (134)..<(135.4):
            staminaPercentage = "70"
        case (135.4)..<(136.8):
            staminaPercentage = "69"
        case (136.8)..<(138.2):
            staminaPercentage = "68"
        case (138.2)..<(141):
            staminaPercentage = "67"
        case (141)..<(142.4):
            staminaPercentage = "66"
        case (142.4)..<(143.8):
            staminaPercentage = "65"
        case (143.8)..<(145.2):
            staminaPercentage = "64"
        case (145.2)..<(146.6):
            staminaPercentage = "63"
        case (146.6)..<(148):
            staminaPercentage = "62"
        case (148)..<(149.4):
            staminaPercentage = "61"
        case (149.4)..<(150.8):
            
            staminaPercentage = "60"
        case (150.8)..<(152.2):
            
            staminaPercentage = "59"
        case (152.2)..<(153.6):
            staminaPercentage = "58"
        case (153.6)..<(155):
            staminaPercentage = "57"
        case (155)..<(156.4):
            staminaPercentage = "56"
        case (156.4)..<(157.8):
            staminaPercentage = "55"
        case (157.8)..<(159.2):
            staminaPercentage = "54"
        case (159.2)..<(160.6):
            staminaPercentage = "53"
        case (160.6)..<(162):
            staminaPercentage = "52"
        case (162)..<(163.4):
            staminaPercentage = "51"
            // MARK: Zone 4, Orange
        case (163.4)..<(164.1):
            staminaPercentage = "50"
        case (164.1)..<(164.8):
            staminaPercentage = "49"
        case (164.8)..<(165.5):
            staminaPercentage = "48"
        case (165.5)..<(166.2):
            staminaPercentage = "47"
        case (166.2)..<(166.9):
            staminaPercentage = "46"
        case (166.9)..<(167.6):
            staminaPercentage = "45"
        case (167.6)..<(168.3):
            staminaPercentage = "44"
        case (168.3)..<(169.0):
            staminaPercentage = "43"
        case (169.0)..<(169.7):
            staminaPercentage = "42"
        case (169.7)..<(170.4):
       
            staminaPercentage = "41"
        case (170.4)..<(171.1):
       
            staminaPercentage = "40"
        case (171.1)..<(171.9):
            
            staminaPercentage = "39"
        case (171.9)..<(172.5):
            staminaPercentage = "38"
        case (172.5)..<(173.2):
            staminaPercentage = "37"
        case (173.2)..<(173.9):
            staminaPercentage = "36"
        case (173.9)..<(174.6):
            staminaPercentage = "35"
        case (174.6)..<(175.3):
            staminaPercentage = "34"
        case (175.3)..<(176.0):
            staminaPercentage = "33"
        case (175.3)..<(176.0):
            staminaPercentage = "32"
        case (176.0)..<(176.7):
     
            staminaPercentage = "31"
        case (176.7)..<(177.4):
            staminaPercentage = "30"
           
            // MARK: Zone 5, Red
        case (177.4)..<(178.4):
            staminaPercentage = "29"
        case (178.4)..<(179.4):
            staminaPercentage = "28"
        case (179.4)..<(180.4):
            staminaPercentage = "27"
        case (180.4)..<(181.4):
            staminaPercentage = "26"
        case (181.4)..<(182.4):
            staminaPercentage = "25"
        case (182.4)..<(183.4):
            staminaPercentage = "24"
        case (183.4)..<(184.4):
            staminaPercentage = "23"
        case (184.4)..<(185.4):
            staminaPercentage = "22"
        case (185.4)..<(186.4):
            staminaPercentage = "21"
        case (186.4)..<(187.4):
            staminaPercentage = "20"
        case (187.4)..<(188.4):
            staminaPercentage = "19"
        case (188.4)..<(189.4):
            staminaPercentage = "18"
        case (189.4)..<(190.4):
            staminaPercentage = "17"
        case (190.4)..<(191.4):
            staminaPercentage = "16"
        case (191.4)..<(192.4):
            staminaPercentage = "15"
        case (192.4)..<(193.4):
            staminaPercentage = "14"
        case (193.4)..<(194.4):
            staminaPercentage = "13"
        case (194.4)..<(195.4):
            staminaPercentage = "12"
        case (195.4)..<(196.4):
            staminaPercentage = "11"
        case (196.4)..<(197.4):
            staminaPercentage = "10"
        case (197.4)..<(198.4):
            staminaPercentage = "9"
        case (198.4)..<(199.4):
            staminaPercentage = "8"
        case (199.4)..<(200.4):
            staminaPercentage = "7"
        case (200.4)..<(201.4):
            staminaPercentage = "6"
        case (201.4)..<(202.4):
            staminaPercentage = "5"
        case (202.4)..<(203.4):
            staminaPercentage = "4"
        case (203.4)..<(204.4):
            staminaPercentage = "3"
        case (204.4)..<(205.4):
            staminaPercentage = "2"
        case (205.4)..<(206):
            staminaPercentage = "1"
        default:
            return AnyView(Text("Invalid Value"))
        }
        
        return AnyView(VStack(alignment: .leading) {
            Image(staminaPercentage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }
    
}
