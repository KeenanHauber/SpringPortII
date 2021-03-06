//
//  UserInfo.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 1/07/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

class User: NSObject {
    
    let username: String
    let countryCode: String // ISO 3166 country code
    let accountId: String?
    
    var status: ClientStatus
    
	var battleStatus: BattleStatus? // TODO: -- Non-optionalise this??
    
    init?(message: String) {
        let components = message.components(separatedBy: " ")
        guard components.count >= 4 else { return nil }
        username = components[1]
        countryCode = components[2]
        if components.count == 5 {
            accountId = components[4]
        } else {
            accountId = nil
        }
        status = ClientStatus(statusString: "0")
    }
    
    override init() {
        username = "foo"
        countryCode = "XX"
        status = ClientStatus(statusString: "0")
        accountId = nil
        super.init()
    }
    
    struct Country {
        let flag: String
        let name: String
    }
    
    var country: Country {
        switch self.countryCode {
        case "AD": return Country(flag: "🇦🇩", name: "Andorra")
        case "AE": return Country(flag: "🇦🇪", name: "United Arab Emirates")
        case "AF": return Country(flag: "🇦🇫", name: "Afghanistan")
        case "AG": return Country(flag: "🇦🇬", name: "Antigua and Barbuda")
        case "AI": return Country(flag: "🇦🇮", name: "Anguilla")
        case "AL": return Country(flag: "🇦🇱", name: "Albania")
        case "AM": return Country(flag: "🇦🇲", name: "Armenia")
        case "AO": return Country(flag: "🇦🇴", name: "Angola")
        case "AQ": return Country(flag: "🇦🇶", name: "Antarctica")
        case "AR": return Country(flag: "🇦🇷", name: "Argentina")
        case "AS": return Country(flag: "🇦🇸", name: "American Samoa")
        case "AT": return Country(flag: "🇦🇹", name: "Australia")
        case "AU": return Country(flag: "🇦🇺", name: "Australia")
        case "AW": return Country(flag: "🇦🇼", name: "Aruba")
        case "AX": return Country(flag: "🇦🇽", name: "Åland Islands")
        case "AZ": return Country(flag: "🇦🇿", name: "Azerbaijan")
        case "BA": return Country(flag: "🇧🇦", name: "Bosnia and Herzegovina")
        case "BB": return Country(flag: "🇧🇧", name: "Barbados")
        case "BD": return Country(flag: "🇧🇩", name: "Bangladesh")
        case "BE": return Country(flag: "🇧🇪", name: "Belgium")
        case "BF": return Country(flag: "🇧🇫", name: "Burkina Faso")
        case "BG": return Country(flag: "🇧🇬", name: "Bulgaria")
        case "BH": return Country(flag: "🇧🇭", name: "Bahrain")
        case "BI": return Country(flag: "🇧🇮", name: "Burundi")
        case "BJ": return Country(flag: "🇧🇯", name: "Benin")
        case "BL": return Country(flag: "🇧🇱", name: "Saint Barthélemy")
        case "BM": return Country(flag: "🇧🇲", name: "Bermuda")
        case "BN": return Country(flag: "🇧🇳", name: "Brunei Darussalam")
        case "BO": return Country(flag: "🇧🇴", name: "Bolivia")
        case "BQ": return Country(flag: "🇧🇶", name: "Bonair, Sint Eustatius and Saba")
        case "BR": return Country(flag: "🇧🇷", name: "Brazil")
        case "BS": return Country(flag: "🇧🇸", name: "Bahamas")
        case "BT": return Country(flag: "🇧🇹", name: "Bhutan")
        case "BV": return Country(flag: "🇳🇴", name: "Bouvet Island")
        case "BW": return Country(flag: "🇧🇼", name: "Botswana")
        case "BY": return Country(flag: "🇧🇾", name: "Belarus")
        case "BZ": return Country(flag: "🇧🇿", name: "Belize")
        case "CA": return Country(flag: "🇨🇦", name: "Canada")
        case "CC": return Country(flag: "🇨🇨", name: "Cocos (Keeling) Islands")
        case "CD": return Country(flag: "❌", name: "The Democratic Republic of the Congo") // TODO -- Flag
        case "CF": return Country(flag: "🇨🇫", name: "Central African Republic")
        case "CG": return Country(flag: "❌", name: "Congo") // TODO: -- Flag
        case "CH": return Country(flag: "🇨🇭", name: "Switzerland")
        case "CI": return Country(flag: "🇨🇮", name: "Côte d'Ivoire (Ivory Coast)")
        case "CK": return Country(flag: "🇨🇰", name: "Cook Islands")
        case "CL": return Country(flag: "🇨🇱", name: "Chile")
        case "CM": return Country(flag: "🇨🇲", name: "Cameroon")
        case "CN": return Country(flag: "🇨🇳", name: "China")
        case "CO": return Country(flag: "🇨🇴", name: "Colombia")
        case "CR": return Country(flag: "🇨🇷", name: "Costa Rica")
        case "CU": return Country(flag: "🇨🇺", name: "Cuba")
        case "CV": return Country(flag: "🇨🇻", name: "Cabo Verde")
        case "CW": return Country(flag: "🇨🇼", name: "Curaçao")
        case "CX": return Country(flag: "🇨🇽", name: "Christmas Island")
        case "CY": return Country(flag: "🇨🇾", name: "Cyprus")
        case "CZ": return Country(flag: "🇨🇿", name: "Czechia (Czech Rebublic)")
        case "DE": return Country(flag: "🇩🇪", name: "Germany")
        case "DJ": return Country(flag: "🇩🇯", name: "Djbouti")
        case "DK": return Country(flag: "🇩🇰", name: "Denmark")
        case "DM": return Country(flag: "🇩🇲", name: "Dominica")
        case "DO": return Country(flag: "🇩🇴", name: "Dominican Republic")
        case "DZ": return Country(flag: "🇩🇿", name: "Algeria")
        case "EC": return Country(flag: "🇪🇨", name: "Ecuador")
        case "EE": return Country(flag: "🇪🇪", name: "Estonia")
        case "ER": return Country(flag: "🇪🇷", name: "Eritrea")
        case "ES": return Country(flag: "🇪🇸", name: "Spain")
        case "ET": return Country(flag: "🇪🇹", name: "Ethiopia")
        case "FI": return Country(flag: "🇫🇮", name: "Finland")
        case "FJ": return Country(flag: "🇫🇯", name: "Fiji")
        case "FK": return Country(flag: "🇫🇰", name: "Falkland Islands (Malvinas)")
        case "FM": return Country(flag: "🇫🇲", name: "Federated Stats of Micronesia")
        case "FO": return Country(flag: "🇫🇴", name: "Faroe Islands")
        case "FR": return Country(flag: "🇫🇷", name: "France")
        case "GA": return Country(flag: "🇬🇦", name: "Gabon")
        case "GB": return Country(flag: "🇬🇧", name: "United Kingdom of Great Britain and Northern Ireland")
        case "GD": return Country(flag: "🇬🇩", name: "Grenada")
        case "GE": return Country(flag: "🇬🇪", name: "Georgia")
        case "GF": return Country(flag: "🇬🇫", name: "French Guiana")
        case "GG": return Country(flag: "🇬🇬", name: "Guernsey")
        case "GH": return Country(flag: "🇬🇭", name: "Ghana")
        case "GI": return Country(flag: "🇬🇮", name: "Gibraltar")
        case "GL": return Country(flag: "🇬🇱", name: "Greenland")
        case "GM": return Country(flag: "🇬🇲", name: "Gambia")
        case "GN": return Country(flag: "🇬🇳", name: "Guinea")
        case "GP": return Country(flag: "🇬🇵", name: "Guadeloupe")
        case "GQ": return Country(flag: "🇬🇶", name: "Equatorial Guinea")
        case "GR": return Country(flag: "🇬🇦", name: "Greece")
        case "GS": return Country(flag: "🇬🇸", name: "South Georgia and the South Sandwich Islands")
        case "GT": return Country(flag: "🇬🇹", name: "Guatemala")
        case "GU": return Country(flag: "🇬🇺", name: "Guam")
        case "GW": return Country(flag: "🇬🇼", name: "Guinea-Bissau")
        case "GY": return Country(flag: "🇬🇾", name: "Guyana")
        case "HK": return Country(flag: "🇭🇰", name: "Hong Kong")
        case "HM": return Country(flag: "🇦🇺", name: "Heard Island and McDonald Islands")
        case "HN": return Country(flag: "🇭🇳", name: "Honduras")
        case "HR": return Country(flag: "🇭🇷", name: "Croatia")
        case "HT": return Country(flag: "🇭🇹", name: "Haiti")
        case "HU": return Country(flag: "🇭🇺", name: "Hungary")
        case "ID": return Country(flag: "🇮🇩", name: "Indonesia")
        case "IE": return Country(flag: "🇮🇪", name: "Ireland")
        case "IL": return Country(flag: "🇮🇱", name: "Israel")
        case "IM": return Country(flag: "🇮🇲", name: "Isle of Man")
        case "IN": return Country(flag: "🇮🇳", name: "India")
        case "IO": return Country(flag: "🇮🇴", name: "British Indian Ocean Territory")
        case "IQ": return Country(flag: "🇮🇶", name: "Iraq")
        case "IR": return Country(flag: "🇮🇷", name: "Iran")
        case "IS": return Country(flag: "🇮🇸", name: "Iceland")
        case "IT": return Country(flag: "🇮🇹", name: "Italy")
        case "JE": return Country(flag: "🇯🇪", name: "Jersey")
        case "JM": return Country(flag: "🇯🇲", name: "Jamaica")
        case "JO": return Country(flag: "🇯🇴", name: "Jordan")
        case "JP": return Country(flag: "🇯🇵", name: "Japan")
        case "KE": return Country(flag: "🇰🇪", name: "Kenya")
        case "KG": return Country(flag: "🇰🇬", name: "Kyrgyzstan")
        case "KH": return Country(flag: "🇰🇭", name: "Cambodia")
        case "KI": return Country(flag: "🇰🇮", name: "Kiribati")
        case "KM": return Country(flag: "🇰🇲", name: "Comoros")
        case "KN": return Country(flag: "🇰🇳", name: "Saint Kitts and Nevis")
        case "KP": return Country(flag: "🇰🇵", name: "North Korea")
        case "KR": return Country(flag: "🇰🇷", name: "South Korea")
        case "KW": return Country(flag: "🇰🇼", name: "Kuwait")
        case "KY": return Country(flag: "🇰🇾", name: "Cayman Islands")
        case "KZ": return Country(flag: "🇰🇿", name: "Kazakhstan")
        case "LA": return Country(flag: "🇱🇦", name: "Laos")
        case "LB": return Country(flag: "🇱🇧", name: "Lebanon")
        case "LC": return Country(flag: "🇱🇨", name: "Saint Lucia")
        case "LI": return Country(flag: "🇱🇮", name: "Liechtenstein")
        case "LK": return Country(flag: "🇱🇰", name: "Sri Lanka")
        case "LR": return Country(flag: "🇱🇷", name: "Liberia")
        case "LS": return Country(flag: "🇱🇸", name: "Lesotho")
        case "LT": return Country(flag: "🇱🇹", name: "Lithuania")
        case "LU": return Country(flag: "🇱🇺", name: "Luxembourg")
        case "LV": return Country(flag: "🇱🇻", name: "Latvia")
        case "LY": return Country(flag: "🇱🇾", name: "Libya")
        case "MA": return Country(flag: "🇲🇦", name: "Morocco")
        case "MC": return Country(flag: "🇲🇨", name: "Monaco")
        case "MD": return Country(flag: "🇲🇩", name: "Moldova")
        case "ME": return Country(flag: "🇲🇪", name: "Montenegro")
        case "MF": return Country(flag: "❌", name: "French Saint Martin")
        case "MG": return Country(flag: "🇲🇬", name: "Madagascar")
        case "MH": return Country(flag: "🇲🇭", name: "Marshall Islands")
        case "MK": return Country(flag: "🇲🇰", name: "Macedonia")
        case "ML": return Country(flag: "🇲🇱", name: "Mali")
        case "MM": return Country(flag: "🇲🇲", name: "Myanmar")
        case "MN": return Country(flag: "🇲🇳", name: "Mongolia")
        case "MO": return Country(flag: "🇲🇴", name: "Macao")
        case "MP": return Country(flag: "🇲🇵", name: "Northern Mariana Islands")
        case "MQ": return Country(flag: "🇲🇶", name: "Martinique")
        case "MR": return Country(flag: "🇲🇷", name: "Mauritania")
        case "MS": return Country(flag: "🇲🇸", name: "Montserrat")
        case "MT": return Country(flag: "🇲🇹", name: "Malta")
        case "MU": return Country(flag: "🇲🇺", name: "Mauritius")
        case "MV": return Country(flag: "🇲🇻", name: "Maldives")
        case "MW": return Country(flag: "🇲🇼", name: "Malawi")
        case "MX": return Country(flag: "🇲🇽", name: "Mexico")
        case "MY": return Country(flag: "🇲🇾", name: "Malaysia")
        case "MZ": return Country(flag: "🇲🇿", name: "Mozambique")
        case "NA": return Country(flag: "🇳🇦", name: "Namibia")
        case "NC": return Country(flag: "🇳🇨", name: "New Caledonia")
        case "NE": return Country(flag: "🇳🇪", name: "Niger")
        case "NF": return Country(flag: "🇳🇫", name: "Norfolk Island")
        case "NG": return Country(flag: "🇳🇬", name: "Nigeria")
        case "NI": return Country(flag: "🇳🇪", name: "Nicaragua")
        case "NL": return Country(flag: "🇳🇱", name: "Netherlands")
        case "NO": return Country(flag: "🇳🇴", name: "Norway")
        case "NP": return Country(flag: "🇳🇵", name: "Nepal")
        case "NR": return Country(flag: "🇳🇷", name: "Nauru")
        case "NU": return Country(flag: "🇳🇺", name: "Niue")
        case "NZ": return Country(flag: "🇳🇿", name: "New Zealand")
        case "OM": return Country(flag: "🇴🇲", name: "Oman")
        case "PA": return Country(flag: "🇵🇦", name: "Panama")
        case "PE": return Country(flag: "🇵🇪", name: "Peru")
        case "PF": return Country(flag: "🇵🇫", name: "French Polynesia")
        case "PG": return Country(flag: "🇵🇬", name: "Papua New Guinea")
        case "PH": return Country(flag: "🇵🇭", name: "Philippines")
        case "PK": return Country(flag: "🇵🇰", name: "Pakistan")
        case "PL": return Country(flag: "🇵🇱", name: "Poland")
        case "PM": return Country(flag: "🇵🇲", name: "Saint Pierre & Miquelon")
        case "PN": return Country(flag: "🇵🇳", name: "Pitcairn")
        case "PR": return Country(flag: "🇵🇷", name: "Puerto Rico")
        case "PS": return Country(flag: "🇵🇸", name: "Palestine")
        case "PT": return Country(flag: "🇵🇹", name: "Portugal")
        case "PW": return Country(flag: "🇵🇼", name: "Palau")
        case "PY": return Country(flag: "🇵🇾", name: "Paraguay")
        case "QA": return Country(flag: "🇶🇦", name: "Qatar")
        case "RE": return Country(flag: "🇷🇪", name: "Réunion")
        case "RO": return Country(flag: "🇷🇴", name: "Romania")
        case "RS": return Country(flag: "🇷🇸", name: "Serbia")
        case "RU": return Country(flag: "🇷🇺", name: "Russian Federation")
        case "RW": return Country(flag: "🇷🇼", name: "Rwanda")
        case "SA": return Country(flag: "🇸🇦", name: "Saudi Arabia")
        case "SB": return Country(flag: "🇸🇧", name: "Solomon Islands")
        case "SC": return Country(flag: "🇸🇨", name: "Seychelles")
        case "SD": return Country(flag: "🇸🇩", name: "Sudan")
        case "SE": return Country(flag: "🇸🇪", name: "Sweden")
        case "SG": return Country(flag: "🇸🇬", name: "Singapore")
        case "SH": return Country(flag: "🇸🇭", name: "Saint Helena, Ascension and Tristan da Cunha")
        case "SI": return Country(flag: "🇸🇮", name: "Slovenia")
        case "SJ": return Country(flag: "❌", name: "Svalbard and Jan Mayen")
        case "SK": return Country(flag: "🇸🇰", name: "Slovakia")
        case "SL": return Country(flag: "🇸🇱", name: "Sierra Leone")
        case "SM": return Country(flag: "🇸🇲", name: "San Marino")
        case "SN": return Country(flag: "🇸🇳", name: "Senegal")
        case "SO": return Country(flag: "🇸🇴", name: "Somalia")
        case "SR": return Country(flag: "🇸🇷", name: "Suriname")
        case "SS": return Country(flag: "🇸🇸", name: "South Sudan")
        case "ST": return Country(flag: "🇸🇹", name: "São Tomé & Príncipe")
        case "SV": return Country(flag: "🇸🇻", name: "El Salvador")
        case "SX": return Country(flag: "🇸🇽", name: "Sint Maarten")
        case "SY": return Country(flag: "🇸🇾", name: "Syrian Arab Republic")
        case "SZ": return Country(flag: "🇸🇿", name: "Swaziland")
        case "TC": return Country(flag: "🇹🇨", name: "Turks and Caicos Islands")
        case "TD": return Country(flag: "🇹🇩", name: "Chad")
        case "TF": return Country(flag: "🇹🇫", name: "French Southern Territories")
        case "TG": return Country(flag: "🇹🇬", name: "Togo")
        case "TH": return Country(flag: "🇹🇭", name: "Thailand")
        case "TJ": return Country(flag: "🇹🇯", name: "Tajikistan")
        case "TK": return Country(flag: "🇹🇰", name: "Tokelau")
        case "TL": return Country(flag: "🇹🇱", name: "Tajikistan")
        case "TM": return Country(flag: "🇹🇲", name: "Turkmenistan")
        case "TN": return Country(flag: "🇹🇳", name: "Tunisia")
        case "TO": return Country(flag: "🇹🇴", name: "Tonga")
        case "TR": return Country(flag: "🇹🇷", name: "Turkey")
        case "TT": return Country(flag: "🇹🇹", name: "Trinidad and Tobago")
        case "TV": return Country(flag: "🇹🇻", name: "Tuvalu")
        case "TW": return Country(flag: "🇹🇼", name: "Taiwan")
        case "TZ": return Country(flag: "🇹🇿", name: "Tanzania")
        case "UA": return Country(flag: "🇺🇦", name: "Ukraine")
        case "UG": return Country(flag: "🇺🇬", name: "Uganda")
        case "UM": return Country(flag: "🇺🇸", name: "United States Minor Outlying Islands")
        case "US": return Country(flag: "🇺🇸", name: "United States of America")
        case "UY": return Country(flag: "🇺🇾", name: "Uruguay")
        case "UZ": return Country(flag: "🇺🇿", name: "Uzbekistan")
        case "VA": return Country(flag: "🇻🇦", name: "Holy See")
        case "VC": return Country(flag: "🇻🇨", name: "Saint Vincent and the Grenadines")
        case "VE": return Country(flag: "🇻🇪", name: "Venezuela")
        case "VG": return Country(flag: "🇻🇬", name: "British Virgin Islands")
        case "VI": return Country(flag: "🇻🇮", name: "U.S. Virgin Islands")
        case "VN": return Country(flag: "🇻🇳", name: "Viet Nam")
        case "VU": return Country(flag: "🇻🇺", name: "Vanuatu")
        case "WF": return Country(flag: "🇼🇫", name: "Wallis and Futuna")
        case "WS": return Country(flag: "🇼🇸", name: "Samoa")
        case "YE": return Country(flag: "🇾🇪", name: "Yemen")
        case "YT": return Country(flag: "🇾🇹", name: "Mayotte")
        case "ZA": return Country(flag: "🇿🇦", name: "South Africa")
        case "ZM": return Country(flag: "🇿🇲", name: "Zambia")
        case "ZW": return Country(flag: "🇿🇼", name: "Zimbabwe")
        default: return Country(flag: "❌", name: "Unknown")
        }
    }
}
