//
//  Extensions.swift
//  CapgoCapacitorPurchases
//
//  Created by Martin DONADIEU on 2023-08-08.
//

import Foundation
import StoreKit

extension Product {

    var dictionary: [String: Any] {
        //        /**
        //         * Currency code for price and original price.
        //         */
        //        readonly currencyCode: string;
        //        /**
        //         * Currency symbol for price and original price.
        //         */
        //        readonly currencySymbol: string;
        //        /**
        //         * Boolean indicating if the product is sharable with family
        //         */
        //        readonly isFamilyShareable: boolean;
        //        /**
        //         * Group identifier for the product.
        //         */
        //        readonly subscriptionGroupIdentifier: string;
        //        /**
        //         * The Product subscription group identifier.
        //         */
        //        readonly subscriptionPeriod: SubscriptionPeriod;
        //        /**
        //         * The Product introductory Price.
        //         */
        //        readonly introductoryPrice: SKProductDiscount | null;
        //        /**
        //         * The Product discounts list.
        //         */
        //        readonly discounts: SKProductDiscount[];
        var product: [String: Any] = [
            "identifier": self.id,
            "description": self.description,
            "title": self.displayName,
            "price": self.price,
            "priceString": self.displayPrice,
            "currencyCode": self.priceFormatStyle.currencyCode,
            "isFamilyShareable": self.isFamilyShareable
        ]

        if let subscription = self.subscription {
            product["subscriptionGroupIdentifier"] = subscription.subscriptionGroupID
            product["subscriptionPeriod"] = StoreKitPayloadHelpers.periodDictionary(
                unit: subscription.subscriptionPeriod.unit,
                value: subscription.subscriptionPeriod.value
            )
        }

        #if STOREKIT_26_5
        if #available(iOS 26.4, *), let pricingTerms = self.subscription?.pricingTerms {
            product["pricingTerms"] = pricingTerms.map { $0.dictionary }
        }
        #endif

        if product["pricingTerms"] == nil,
           let productJSON = StoreKitPayloadHelpers.jsonDictionary(from: self.jsonRepresentation),
           let pricingTerms = StoreKitPayloadHelpers.pricingTerms(from: productJSON) {
            product["pricingTerms"] = pricingTerms
        }

        return product
    }
}
