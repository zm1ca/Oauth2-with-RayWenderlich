/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

/**
Standard claims as described in spec: http://openid.net/specs/openid-connect-core-1_0.html#StandardClaims
*/
open class OpenIdClaim: CustomStringConvertible {
    /// Subject - Identifier for the End-User at the Issuer.
    open var sub: String?
    /// End-User's full name in displayable form including all name parts, possibly including titles and suffixes, ordered according to the End-User's locale and preferences.
    open var name: String?
    /// Given name(s) or first name(s) of the End-User.
    open var givenName: String?
    /// Surname(s) or last name(s) of the End-User.
    open var familyName: String?
    /// Middle name(s) of the End-User.
    open var middleName: String?
    /// Casual name of the End-User that may or may not be the same as the given_name.
    open var nickname: String?
    /// Shorthand name by which the End-User wishes to be referred to at the RP, such as janedoe or j.doe.
    open var preferredUsername: String?
    /// URL of the End-User's profile page.
    open var profile: String?
    /// URL of the End-User's profile picture. This URL MUST refer to an image file (for example, a PNG, JPEG, or GIF image file), rather than to a Web page containing an image.
    open var picture: String?
    /// URL of the End-User's Web page or blog. This Web page SHOULD contain information published by the End-User or an organization that the End-User is affiliated with.
    open var website: String?
    /// End-User's preferred e-mail address.
    open var email: String?
    /// True if the End-User's e-mail address has been verified; otherwise false.
    open var emailVerified: Bool?
    /// End-User's gender. Values defined by this specification are female and male. Other values MAY be used when neither of the defined values are applicable.
    open var gender: String?
    /// End-User's birthday, represented as an ISO 8601:2004 [ISO8601???2004] YYYY-MM-DD format.
    open var birthdate: String?
    /// String from zoneinfo [zoneinfo] time zone database representing the End-User's time zone. For example, Europe/Paris or America/Los_Angeles.
    open var zoneinfo: String?
    /// [ISO3166???1] country code in uppercase, separated by a dash. For example, en-US or fr-CA.
    open var locale: String?
    /// End-User's preferred telephone number.
    open var phoneNumber: String?
    /// True if the End-User's phone number has been verified; otherwise false.
    open var phoneNumberVerified: Bool?
    /// End-User's preferred postal address.
    open var address: [String: AnyObject?]?
    /// Time the End-User's information was last updated.
    open var updatedAt: Int?
    // google specific - not in spec?
    open var kind: String?
    open var hd: String?
    /// Display all the claims.
    open var description: String {
        return  "sub: \(String(describing: sub))\nname: \(String(describing: name))\ngivenName: \(String(describing: givenName))\nfamilyName: \(String(describing: familyName))\nmiddleName: \(String(describing: middleName))\n" +
            "nickname: \(String(describing: nickname))\npreferredUsername: \(String(describing: preferredUsername))\nprofile: \(String(describing: profile))\npicture: \(String(describing: picture))\n" +
        "website: \(String(describing: website))\nemail: \(String(describing: email))\nemailVerified: \(String(describing: emailVerified))\ngender: \(String(describing: gender))\nbirthdate: \(String(describing: birthdate))\n"
    }

    /// Initialize an OpenIDClaim from a dictionary. all information not available are optional values set to .None.
    public init(fromDict: [String: AnyObject]) {
        sub = fromDict["sub"] as? String
        name = fromDict["name"] as? String
        givenName = fromDict["given_name"] as? String
        familyName = fromDict["family_name"] as? String
        middleName = fromDict["middle_name"] as? String
        nickname = fromDict["nickname"] as? String
        preferredUsername = fromDict["preferred_username"] as? String
        profile = fromDict["profile"] as? String
        picture = fromDict["picture"] as? String
        website = fromDict["website"] as? String
        email = fromDict["email"] as? String
        emailVerified = fromDict["email_verified"] as? Bool
        gender = fromDict["gender"] as? String
        zoneinfo = fromDict["zoneinfo"] as? String
        locale = fromDict["locale"] as? String
        phoneNumber = fromDict["phone_number"] as? String
        phoneNumberVerified = fromDict["phone_number_verified"] as? Bool
        updatedAt = fromDict["updated_at"] as? Int
        kind = fromDict["sub"] as? String
        hd = fromDict["hd"] as? String
    }
}
/// Facebook specific claims.
open class FacebookOpenIdClaim: OpenIdClaim {

    override init(fromDict: [String: AnyObject]) {
        super.init(fromDict: fromDict)
        givenName = fromDict["first_name"] as? String
        familyName = fromDict["last_name"] as? String
        zoneinfo = fromDict["timezone"] as? String
    }
}
