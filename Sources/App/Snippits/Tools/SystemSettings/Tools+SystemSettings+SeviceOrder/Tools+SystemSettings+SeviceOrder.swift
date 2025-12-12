//
//  Tools+SystemSettings+SeviceOrder.swift
//  
//
//  Created by Victor Cantu on 9/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings {
    
    class SeviceOrder: Div {
        
        override class var name: String { "div" }
        
        let configStoreProcessing: ConfigStoreProcessing
        
        let configContactTags: ConfigContactTags
        
        init(
            configStoreProcessing: ConfigStoreProcessing,
            configContactTags: ConfigContactTags
        ) {
            self.configStoreProcessing = configStoreProcessing
            self.configContactTags = configContactTags
            
            super.init()
            
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        /// `ConfigStoreProcessing`
        
        /// Order Procesing is active
        /// order, rental, date
        var moduleProfile: [CustOrderProfiles] = []
        
        @State var moduleProfileOrder: Bool = false
        
        @State var moduleProfileRental: Bool = false
        
        @State var moduleProfileDate: Bool = false
        
        /// What view will be used in the sistem by default
        /// CustOrderGridView
        /// list, calendar
        @State var gridView: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var accountMobileConfirmationMode: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var accountIdConfirmationMode: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var orderMobileConfirmationMode: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var rentalMobileConfirmationMode: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var dateMobileConfirmationMode: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var orderIdConfirmationMode: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var rentalIdConfirmationMode: String = ""
        
        /// `ConfirmationMode`
        /// strict, recomended, unrecomended
        @State var dateIdConfirmationMode: String = ""
        
        /// `CreateAccountMode`
        /// minimal, basicAuth, compleatAuth
        @State var createPersonalAccountMode: String = ""
        
        /// `CreateAccountMode`
        /// minimal, basicAuth, compleatAuth
        @State var createBuisnessAccountMode: String = ""
        
        /// `Currencies`
        /// Currency EUR, USD, MXN
        @State var currency: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level on to an order can be created with out at least one charge
        @State var restrictOrderCreation: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level on to an order can be closed with pending balance
        @State var restrictOrderClosing: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level on to where a charge can be registerd on an order that is not a registerd SOC or POC
        @State var restrictOrderCharges: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level on to where a charge can be registerd on an sale that is not a registerd SOC or POC
        @State var restrictSaleCharges: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level to where can delete inventory items
        @State var restrictMermProduct: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level to where can delete a charge from a sale o service order
        @State var restrictDeleteCharges: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level to where can delete a payment from a sale o service order
        @State var restrictDeletePayments: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level to where can fiscal document can be deleted
        @State var restrictDeleteFiscal: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// In how many days the notification will be delete if not seen.
        @State var autoDeleteCTAM: String = ""
        
        /// `UsernameRoles` (Int Value)
        /// What is the minimum level on to where a fiscal invoce can be creted with manual charges
        @State var openFiscalInvoce: String = ""
        
        /// What comision is the general comision over the erning for the sale agent
        @State var generalComision: String = ""
        
        /// View the price on the webpage
        @State var viewPricesOnWeb: Bool = false
        
        /// "Precios pueden cambiar sin previo aviso."
        @State var varialPricesDisclosure: Bool = false
        
        @State var lastServicePriceRangeID: UUID? = nil
        
        /// Sugest sale price based on the cost of the service
        @State var servicePriceRange: [PriceRangeItem] = []
        
        @State var lastProductPriceRangeID: UUID? = nil
        
        /// Sugest sale price based on the cost of the product
        @State var productPriceRange: [PriceRangeItem] = []
        
        /*🔸 Citas y recordatorios 🔸*/
        /// Send Push Notification of the pending orders for that day
        @State var orderDateReminderMorning: Bool = false
        
        /// Send Puch Notification of the pending orders during the day
        @State var orderDateReminderConcurring: Bool = false
        
        /// An asigned user to attend dates
        var orderDateReminderAssistedOperator: String = ""
        
        /// Sends mesages reminding customer to pick up their products
        @State var orderPendingPickupLimitAlert: Bool = false
        
        /// When will the sistem start reminding abought pending pick up orders
        @State var orderPendingPickupLimitStart: String = ""
        
        /// When will the sistem stop reminding abought pending pick up orders
        @State var orderPendingPickupLimitEnd: String = ""
        
        /// Every how many days will the sistem be reremindingf about pending pick up orders
        @State var orderPendingPickupLimitEveryWhen: String = ""
        
        /// generic mesage of recuring reminder of pending pick up orders
        @State var orderPendingPickupLimitEveryWhenMsg: String = ""
        
        /// message of pending pick up orders @ 3 days befor the orderPendingPickupLimitEnd
        @State var orderPendingPickupLimitThreeDayAlertMsg: String = ""
        
        /// message of pending pick up orders @ 1 days befor the orderPendingPickupLimitEnd
        @State var orderPendingPickupLimitOneDayAlertMsg: String = ""
        
        /// message of pending pick up orders @ 0 days befor the orderPendingPickupLimitEnd
        @State var orderPendingPickupLimitZeroDayAlertMsg: String = ""
        
        @State var orderContract: String = ""
        
        /*🔸 Manejo de Inventario en venta / orden 🔸*/
        
        /// if the prorduct sold is remove form inventory directly or has a midle man on storage
        /// Controls how is the produst are removed from service order
        /// ProductDeliveryType
        /// direct, indirect
        @State var orderAddedProductDelivery: String = ""
        
        /// if the prorduct sold is remove form inventory directly or has a midle man on storage
        /// Controls how is the produst are removed from service order
        /// ProductDeliveryType
        /// direct, indirect
        @State var saleProductDelivery: String = ""
        
        /*🔸 Membresias / Creditos y cobranzas 🔸*/
        
        /// StoreCreditType
        /// month, byweek, week, perevent
        @State var creditType: String = ""
        
        @State var billingDate: String = ""
        
        @State var creditDays: String = ""
        
        @State var initialCreditLimit: String = ""
        
        @State var creditRequisitObject: [String] = []
        
        /*🔸 Rewards Programe 🔸*/
        
        /// lowTicket, medTicket, highTicket, premiumTicket
        @State var rewardsStructureTypeHelper: RewardsProgramType? = nil
        
        /// What if any rewordsprogram will be active
        /// RewardsProgramType?
        /// lowTicket, medTicket, highTicket, premiumTicket
        @State var rewardsStructureType: String = ""
        
        /// How many global points are required to belong to belong to this level. Recomended 0
        @State var rewardsTierClubBreak: String = ""
        
        /// How many global points are required to belong to belong to this level. Recomended 1000
        @State var rewardsTierBronceBreak: String = ""
        
        /// How many global points are required to belong to belong to this level. Recomended 3000
        @State var rewardsTierSilverBreak: String = ""
        
        /// How many global points are required to belong to belong to this level. Recomended 10000
        @State var rewardsTierGoldBreak: String = ""
        
        /// How many global points are required to belong to belong to this level. Recomended 50000
        @State var rewardsTierDiamondBreak: String = ""
        
        /// What reward will be recived on product purchase based on revenue on CLUB level
        @State var rewardsPercentProductTierClub: String = ""
        
        /// What reward will be recived on product purchase based on revenue on BRONCE level
        @State var rewardsPercentProductTierBronce: String = ""
        
        /// What reward will be recived on product purchase based on revenue on SILVER level
        @State var rewardsPercentProductTierSilver: String = ""
        
        /// What reward will be recived on product purchase based on revenue on GOLD level
        @State var rewardsPercentProductTierGold: String = ""
        
        /// What reward will be recived on product purchase based on revenue on DIAMOND level
        @State var rewardsPercentProductTierDiamond: String = ""
        
        /// What reward will be recived on contarcted services based on revenue on CLUB level
        @State var rewardsPercentServiceTierClub: String = ""
        
        /// What reward will be recived on contarcted services based on revenue on BRONCE level
        @State var rewardsPercentServiceTierBronce: String = ""
        
        /// What reward will be recived on contarcted services based on revenue on SILVER level
        @State var rewardsPercentServiceTierSilver: String = ""
        
        /// What reward will be recived on contarcted services based on revenue on GOLD level
        @State var rewardsPercentServiceTierGold: String = ""
        
        /// What reward will be recived on contarcted services based on revenue on DIAMOND level
        @State var rewardsPercentServiceTierDiamond: String = ""
        
        @State var rewardsRefrenceTierOne: String = ""
        
        @State var rewardsRefrenceTierTwo: String = ""
        
        @State var rewardsRefrenceTierThree: String = ""
        
        @State var welcomeGift: [RewardsProgramWelcomeItems] = []
        
        /// What rewars will  be recived  at this level
        @State var rewardsTierClubItems: [RewardsProgramItems] = []
        
        /// What rewars will  be recived  at this level
        @State var rewardsTierBronceItems: [RewardsProgramItems] = []
        
        /// What rewars will  be recived  at this level
        @State var rewardsTierSilverItems: [RewardsProgramItems] = []
        
        /// What rewars will  be recived  at this level
        @State var rewardsTierGoldItems: [RewardsProgramItems] = []
        
        /// What rewars will  be recived  at this level
        @State var rewardsTierDiamondItems: [RewardsProgramItems] = []
        
        /// Order Inscription mode invols service, rental, sale orders
        /// ConfirmationMode required, recomended, optinal
        @State var orderOpenInscriptionMode: String = ConfirmationMode.recomended.rawValue
                   
        /// Order Inscription mode invols service, rental, sale orders
        /// ConfirmationMode required, recomended, optinal
        @State var orderCloseInscriptionMode: String = ConfirmationMode.recomended.rawValue
        
        /// Point Of Sale
        /// ConfirmationMode required, recomended, optinal
        @State var pointOfSaleCloseInscriptionMode: String = ConfirmationMode.recomended.rawValue
        
        /// Creating new account
        /// ConfirmationMode required, recomended, optinal
        @State var newAccountCloseInscriptionMode: String = ConfirmationMode.optional.rawValue
        
        /// The order creation folio sequence type
        /// SerializationSequenceType
        @State var orderSerialization: String = SerializationSequenceType.sequence.rawValue
        
        /// The sale creation folio sequence type
        /// SerializationSequenceType
        @State var saleSerialization: String = SerializationSequenceType.sequence.rawValue
        
        /// The fical document creation folio sequence type
        /// SerializationSequenceType
        @State var fiscalSerialization: String = SerializationSequenceType.sequence.rawValue
        
        
        /// `ConfigContactTags`
        
        
        /// If cust requiers some institute tag to make difrence
        @State var requireInstituteTag: Bool = false
        
        /// `ConfigConfigContactTagsInstitudType`
        /// What might be the tag of the institute
        @State var instituteTag: String = ""
        
        /// `ConfigConfigContactTagsCustomerType`
        /// customer, subscriber, patients, student
        @State var customerType: String = ""
        
        /// Address of where service will be prefomed
        @State var requierServiceAddress: Bool = false
        
        /// Address of where printed notification are sent
        @State var requierMailingAddrees: Bool = false
        
        /// Address of where home/business/organization is located
        @State var requirePhysicalAddress: Bool = false
        
        @State var operationalContact: String = ""
        
        @State var salesContact: String = ""
        
        @State var finacialContact: String = ""
        
        @State var sendNewBusinessAccountComunication: Bool = false
        
        var rewardsViewRefrence: [UUID: Div] = [:]
        
        
        /// ⚠️ `Input Elements`
        
        
        lazy var moduleProfileOrderCheckbox = InputCheckbox().toggle(self.$moduleProfileOrder)
        
        lazy var moduleProfileRentalCheckbox = InputCheckbox().toggle(self.$moduleProfileRental)
        
        lazy var moduleProfileDateCheckbox = InputCheckbox().toggle(self.$moduleProfileDate)
        
        lazy var gridViewSelect = Select(self.$gridView)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var accountMobileConfirmationModeSelect = Select(self.$accountMobileConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var accountIdConfirmationModeSelect = Select(self.$accountIdConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var orderMobileConfirmationModeSelect = Select(self.$orderMobileConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var rentalMobileConfirmationModeSelect = Select(self.$rentalMobileConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var dateMobileConfirmationModeSelect = Select(self.$dateMobileConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var orderIdConfirmationModeSelect = Select(self.$orderIdConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var rentalIdConfirmationModeSelect = Select(self.$rentalIdConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var createPersonalAccountModeSelect = Select(self.$createPersonalAccountMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var createBuisnessAccountModeSelect = Select(self.$createBuisnessAccountMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var dateIdConfirmationModeSelect = Select(self.$dateIdConfirmationMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        
        lazy var currencySelect = Select(self.$currency)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        
        lazy var restrictOrderCreationSelect = Select(self.$restrictOrderCreation)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var restrictOrderClosingSelect = Select(self.$restrictOrderClosing)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var restrictOrderChargesSelect = Select(self.$restrictOrderCharges)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var restrictSaleChargesSelect = Select(self.$restrictSaleCharges)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var restrictMermProductSelect = Select(self.$restrictMermProduct)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var restrictDeleteChargesSelect = Select(self.$restrictDeleteCharges)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var restrictDeletePaymentsSelect = Select(self.$restrictDeletePayments)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var restrictDeleteFiscalSelect = Select(self.$restrictDeleteFiscal)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var autoDeleteCTAMField = InputText(self.$autoDeleteCTAM)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("X Dias")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var openFiscalInvoceSelect = Select(self.$openFiscalInvoce)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var generalComisionField = InputText(self.$generalComision)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("0~100")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
            
        lazy var saleSerializationSelect = Select(self.$saleSerialization)
            .class(.textFiledBlackDark)
            .width(95.percent)

        lazy var orderSerializationSelect = Select(self.$orderSerialization)
            .class(.textFiledBlackDark)
            .width(95.percent)

        lazy var fiscalSerializationSelect = Select(self.$fiscalSerialization)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        
        /*🔸 Citas y recordatorios 🔸*/
        
        lazy var viewPricesOnWebCheckbox = InputCheckbox().toggle(self.$viewPricesOnWeb)
        
        lazy var varialPricesDisclosureCheckbox = InputCheckbox().toggle(self.$varialPricesDisclosure)
        
        // orderDateReminderAssistedOperator
        
        /// Sends mesages reminding customer to pick up their products
        lazy var orderPendingPickupLimitAlertCheckbox = InputCheckbox().toggle(self.$orderPendingPickupLimitAlert)
        
        /// When will the sistem start reminding abought pending pick up orders
        lazy var orderPendingPickupLimitStartField = InputText(self.$orderPendingPickupLimitStart)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("")
        
        /// When will the sistem stop reminding abought pending pick up orders
        lazy var orderPendingPickupLimitEndField = InputText(self.$orderPendingPickupLimitEnd)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("")
        
        /// Every how many days will the sistem be reremindingf about pending pick up orders
        lazy var orderPendingPickupLimitEveryWhenField = InputText(self.$orderPendingPickupLimitEveryWhen)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("")
        
        /// generic mesage of recuring reminder of pending pick up orders
        lazy var orderPendingPickupLimitEveryWhenMsgTextArea = TextArea(self.$orderPendingPickupLimitEveryWhenMsg)
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(70.px)
            .placeholder("")
        
        /// message of pending pick up orders @ 3 days befor the orderPendingPickupLimitEnd
        lazy var orderPendingPickupLimitThreeDayAlertMsgTextArea = TextArea(self.$orderPendingPickupLimitThreeDayAlertMsg)
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(70.px)
            .placeholder("")
        
        /// message of pending pick up orders @ 1 days befor the orderPendingPickupLimitEnd
        lazy var orderPendingPickupLimitOneDayAlertMsgTextArea = TextArea(self.$orderPendingPickupLimitOneDayAlertMsg)
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(70.px)
            .placeholder("")
        
        /// message of pending pick up orders @ 0 days befor the orderPendingPickupLimitEnd
        lazy var orderPendingPickupLimitZeroDayAlertMsgTextArea = TextArea(self.$orderPendingPickupLimitZeroDayAlertMsg)
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(70.px)
            .placeholder("")
        
        lazy var orderContractTextArea = TextArea(self.$orderContract)
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(70.px)
            .placeholder("")
        
        /*🔸 Manejo de Inventario en venta / orden 🔸*/
        
        /// if the prorduct sold is remove form inventory directly or has a midle man on storage
        /// Controls how is the produst are removed from service order
        /// direct, indirect
        lazy var orderAddedProductDeliverySelect = Select(self.$orderAddedProductDelivery)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /// if the prorduct sold is remove form inventory directly or has a midle man on storage
        /// Controls how is the produst are removed from service order
        /// direct, indirect
        lazy var saleProductDeliverySelect = Select(self.$saleProductDelivery)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /*🔸 Membresias / Creditos y cobranzas 🔸*/
        
        /// StoreCreditType
        /// month, byweek, week, perevent
        lazy var creditTypeSelect = Select(self.$creditType)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var billingDateField = InputText(self.$billingDate)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("1~31")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var creditDaysField = InputText(self.$creditDays)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Dias")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var initialCreditLimitField = InputText(self.$initialCreditLimit)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("1,000.00")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        // creditRequisitObject
        
        /// If cust requiers some institute tag to make difrence
        lazy var requireInstituteTagCheckbox = InputCheckbox().toggle(self.$requireInstituteTag)
        
        /// `ConfigConfigContactTagsInstitudType`
        /// What might be the tag of the institute
        lazy var instituteTagSelect = Select(self.$instituteTag)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /// ConfigConfigContactTagsCustomerType
        /// customer, subscriber, patients, student
        lazy var customerTypeSelect = Select(self.$customerType)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /// Address of where service will be prefomed
        lazy var requierServiceAddressCheckbox = InputCheckbox().toggle(self.$requierServiceAddress)
        
        /// Address of where printed notification are sent
        lazy var requierMailingAddreesCheckbox = InputCheckbox().toggle(self.$requierMailingAddrees)
        
        /// Address of where home/business/organization is located
        lazy var requirePhysicalAddressCheckbox = InputCheckbox().toggle(self.$requirePhysicalAddress)
        
        /// users [CustUsername]
        lazy var operationalContactSelect = Select(self.$operationalContact)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /// users [CustUsername]
        lazy var salesContactSelect = Select(self.$salesContact)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /// users [CustUsername]
        lazy var finacialContactSelect = Select(self.$finacialContact)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var sendNewBusinessAccountComunicationCheckbox = InputCheckbox().toggle(self.$sendNewBusinessAccountComunication)
        
        
        /*🔸 Rewards Programe 🔸*/
        
        
        /// RewardsProgramType?
        /// lowTicket, medTicket, highTicket, premiumTicket
        lazy var rewardsStructureTypeSelect = Select(self.$rewardsStructureType)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var rewardsTierClubBreakField = InputText(self.$rewardsTierClubBreak)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("0")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsTierBronceBreakField = InputText(self.$rewardsTierBronceBreak)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("1000")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsTierSilverBreakField = InputText(self.$rewardsTierSilverBreak)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("3000")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsTierGoldBreakField = InputText(self.$rewardsTierGoldBreak)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("10000")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsTierDiamondBreakField = InputText(self.$rewardsTierDiamondBreak)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("50000")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentProductTierClubField = InputText(self.$rewardsPercentProductTierClub)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("9.0")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentProductTierBronceField = InputText(self.$rewardsPercentProductTierBronce)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("10.5")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentProductTierSilverField = InputText(self.$rewardsPercentProductTierSilver)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("12.0")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentProductTierGoldField = InputText(self.$rewardsPercentProductTierGold)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(85.percent)
            .placeholder("13.5")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentProductTierDiamondField = InputText(self.$rewardsPercentProductTierDiamond)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("15.0")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentServiceTierClubField = InputText(self.$rewardsPercentServiceTierClub)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("9.0")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentServiceTierBronceField = InputText(self.$rewardsPercentServiceTierBronce)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("10.5")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentServiceTierSilverField = InputText(self.$rewardsPercentServiceTierSilver)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("12.0")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentServiceTierGoldField = InputText(self.$rewardsPercentServiceTierGold)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("13.5")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsPercentServiceTierDiamondField = InputText(self.$rewardsPercentServiceTierDiamond)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(73.percent)
            .placeholder("15.0")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsRefrenceTierOneField = InputText(self.$rewardsRefrenceTierOne)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .placeholder("10000")
            .marginLeft(12.px)
            .width(50.percent)
            .textAlign(.right)
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsRefrenceTierTwoField = InputText(self.$rewardsRefrenceTierTwo)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .placeholder("25000")
            .marginLeft(12.px)
            .width(50.percent)
            .textAlign(.right)
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var rewardsRefrenceTierThreeField = InputText(self.$rewardsRefrenceTierThree)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .placeholder("50000")
            .marginLeft(12.px)
            .width(50.percent)
            .textAlign(.right)
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        lazy var orderOpenInscriptionModeSelect = Select(self.$orderOpenInscriptionMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var orderCloseInscriptionModeSelect = Select(self.$orderCloseInscriptionMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var pointOfSaleCloseInscriptionModeModeSelect = Select(self.$pointOfSaleCloseInscriptionMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var newAccountCloseInscriptionModeModeSelect = Select(self.$newAccountCloseInscriptionMode)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /// [RewardsProgramWelcomeItems]
        lazy var welcomeGiftDiv = Div()
        
        /// [RewardsProgramItems]
        lazy var rewardsTierClubItemsDiv = Div()
        
        /// [RewardsProgramItems]
        lazy var rewardsTierBronceItemsDiv = Div()
        
        /// [RewardsProgramItems]
        lazy var rewardsTierSilverItemsDiv = Div()
        
        /// [RewardsProgramItems]
        lazy var rewardsTierGoldItemsDiv = Div()
        
        /// [RewardsProgramItems]
        lazy var rewardsTierDiamondItemsDiv = Div()
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                H3("Configuración de Contacto").color(.lightBlueText)
                
                /// Categoria de cliente primario
                Div{
                    Div{
                        Label("Requiere Categoria de cliente")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.requireInstituteTagCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                
                /// Categoria de cliente primario
                Div{
                    Div{
                        Label("Categoria de cliente primario")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.instituteTagSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Tipo de clientes
                Div{
                    Div{
                        Label("Tipo de clientes")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.customerTypeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Direccion de Servicio
                Div{
                    Div{
                        Label("Direccion de Servicio")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.requierServiceAddressCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Direccion de Correspondencia
                Div{
                    Div{
                        Label("Direccion de Correspondencia")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.requierMailingAddreesCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Direccion Fisica
                Div{
                    Div{
                        Label("Direccion Fisica")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.requirePhysicalAddressCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Contacto Operativo
                Div{
                    Div{
                        Label("Contacto Operativo")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.operationalContactSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Contacto de ventas
                Div{
                    Div{
                        Label("Contacto de ventas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.salesContactSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Contacto fiscal
                Div{
                    Div{
                        Label("Contacto Fiscal")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.finacialContactSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Enviar Comunicacion Especial Empresas
                Div{
                    Div{
                        Label("Enviar Comunicacion Especial Empresas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.sendNewBusinessAccountComunicationCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Configuracions Generales").color(.lightBlueText)
                
                /// Tipo de monera
                Div{
                    Div{
                        Label("Tipo de Monerda")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.currencySelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Dias para eliminar notificaciónes
                Div{
                    Div{
                        Label("Dias para eliminar notificaciónes")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.autoDeleteCTAMField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                   
                /// `Modulos Activos`
                Div{
                    Label("Modulos de ordens activos")
                        .color(.white)
                    Div().clear(.both).height(3.px)
                    Div{
                        Div("Ordenes")
                            .marginBottom(3.px)
                            .color(.lightGray)
                        self.moduleProfileOrderCheckbox
                    }
                    .width(33.percent)
                    .float(.left)
                    Div{
                        Div("Rentas")
                            .marginBottom(3.px)
                            .color(.lightGray)
                        self.moduleProfileRentalCheckbox
                    }
                    .width(33.percent)
                    .float(.left)
                    Div{
                        Div("Citas")
                            .marginBottom(3.px)
                            .color(.lightGray)
                        self.moduleProfileDateCheckbox
                    }
                    .width(33.percent)
                    .float(.left)
                }
                Div().clear(.both).height(7.px)
                
                /// Default Grid View
                Div{
                    Div{
                        Label("Vista de ordenes principal")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.gridViewSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                
                ///
                Div{
                    Div{
                        Label("Serializacion de Ventas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.saleSerializationSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)

                
                ///
                Div{
                    Div{
                        Label("Serializacion de Ordens")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.orderSerializationSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                
                ///
                Div{
                    Div{
                        Label("Serializacion de Facturas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.fiscalSerializationSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Comision General
                Div{
                    Div{
                        Label("Comisione general al vendedor")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.generalComisionField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Ver Precios en Web
                Div{
                    Div{
                        Label("Ver Precios en Web")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.viewPricesOnWebCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Price can varyy
                Div{
                    Div{
                        Label("Leyenda: \"Precios Varian\"")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.varialPricesDisclosureCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Comision General
                Div{
                    Div{
                        Label("Comisione general al vendedor")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.generalComisionField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Información requerida al crear cuenta").color(.lightBlueText)
                
                /// Confirm Mobile [Rental]
                Div{
                    Div{
                        Label("Cuentas Personales")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.createPersonalAccountModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Confirmar Identidad [Rental]
                Div{
                    Div{
                        Label("Cuentas Empresariales")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.createBuisnessAccountModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Configuraciones de la Cuenta").color(.lightBlueText)
                
                /// Cofimar Movil [Account]
                Div{
                    Div{
                        Label("Cofimar Movil al Crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.accountMobileConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Confimar ID [Account]
                Div{
                    Div{
                        Label("Confimar ID al crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.accountIdConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Configuraciones de la Orden").color(.lightBlueText)
                
                /// Confirmar Mobile[Orden]
                Div{
                    Div{
                        Label("Confirmar Mobile al Crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.orderMobileConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Confirmar ID [Order]
                Div{
                    Div{
                        Label("Confirmar ID al Crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.orderIdConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Incluir Cargos al crear
                Div{
                    Div{
                        Label("Generar sin cargos")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictOrderCreationSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Incluir Cargos al cerrar
                Div{
                    Div{
                        Label("Finalizar con Balance")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictOrderClosingSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Cargos Manuales
                Div{
                    Div{
                        Label("Cargos Manuales")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictOrderChargesSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Eliminar Cargos (SVC)
                Div{
                    Div{
                        Label("Eliminar Cargos (servicios)")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictDeleteChargesSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Eliminar Productos
                Div{
                    Div{
                        Label("Elimnar Productos")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictDeletePaymentsSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Restriciones de Rentas").color(.lightBlueText)
                
                /// Confirm Mobile [Rental]
                Div{
                    Div{
                        Label("Confirmar Movil al Crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.rentalMobileConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Confirmar Identidad [Rental]
                Div{
                    Div{
                        Label("Confirmar ID al Crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.rentalIdConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Restriciones de Citas").color(.lightBlueText)
                
                /// Confirm Mobile [Date]
                Div{
                    Div{
                        Label("Confirm Mobile al Crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.dateMobileConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Confirmar Identidad [Date]
                Div{
                    Div{
                        Label("Confirmar ID al Crear")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.dateIdConfirmationModeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Restriciones Generales").color(.lightBlueText)
                
                /// Eliminar Ventas
                Div{
                    Div{
                        Label("Eliminar Ventas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictSaleChargesSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Mermar Productos
                Div{
                    Div{
                        Label("Mermar Productos")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictMermProductSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Eliminar Facturas
                Div{
                    Div{
                        Label("Eliminar Facturas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictDeleteFiscalSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Eliminar Facturas
                Div{
                    Div{
                        Label("Eliminar Facturas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.restrictDeleteFiscalSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Facturas Manuales
                Div{
                    Div{
                        Label("Facturas Cargos Manuales")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.openFiscalInvoceSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                
                Div{
                    Img()
                        .src("/skyline/media/add.png")
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .cursor(.pointer)
                        .float(.right)
                        .height(18.px)
                        .onClick {
                            
                            let id = UUID()
                            
                            var lastUpperRange: Int64 = 0
                            
                            var upperRange: Int64 = 0
                            
                            var modifirea: Int64 = 0
                            
                            var modifireb: Int64 = 0
                            
                            var modifirec: Int64 = 0
                            
                            if let range = self.servicePriceRange.last {
                                
                                guard let _lowerRange = Double( range.lowerRange.replace(from: ",", to: "") ) else {
                                    return
                                }
                                
                                guard let  _upperRange = Double( range.upperRange.replace(from: ",", to: "") ) else {
                                    showError(.errorGeneral, "Incluya rango superior")
                                    range.lowerRangeField.select()
                                    return
                                }
                                
                                guard _upperRange > _lowerRange else {
                                    showError(.errorGeneral, "Rango superior debe ser mayor al rango menor")
                                    return
                                }
                                
                                if range.pricea.isEmpty {
                                    showError(.errorGeneral, "Incluya rango pordentaje a")
                                    range.lowerRangeField.select()
                                    return
                                }
                                
                                if range.priceb.isEmpty {
                                    showError(.errorGeneral, "Incluya rango pordentaje b")
                                    range.lowerRangeField.select()
                                    return
                                }
                                if range.pricec.isEmpty {
                                    showError(.errorGeneral, "Incluya rango pordentaje c")
                                    range.lowerRangeField.select()
                                    return
                                }
                                
                                let _lastUpperRange = (_upperRange + 1.toDouble)
                                
                                lastUpperRange = _lastUpperRange.toCents
                                
                                let newRange = (_lastUpperRange * PriceRanger.getRange(lastRange: lastUpperRange))
                                
                                upperRange = newRange.toCents
                                
                                let base = PriceRanger.getPercentBase(lastRange: lastUpperRange, newRange: upperRange)
                                
                                guard let pricea = Double(range.pricea) else {
                                    return
                                }
                                
                                let newPricea = pricea - (pricea * base)
                                
                                let percents = PriceRanger.getPercentLevels(base: newPricea)
                                
                                modifirea = percents.pricea.toCents
                                modifireb = percents.priceb.toCents
                                modifirec = percents.pricec.toCents
                                
                            }
                            else {
                                upperRange = 500
                                
                                let percents = PriceRanger.getPercentLevels(base: 180.00)
                                
                                modifirea = percents.pricea.toCents
                                modifireb = percents.priceb.toCents
                                modifirec = percents.pricec.toCents
                            }
                            
                            self.lastServicePriceRangeID = id
                            
                            self.servicePriceRange.append(.init(
                                rangeNumber: (self.servicePriceRange.count + 1),
                                currentLastRange: self.$lastServicePriceRangeID,
                                item: .init(
                                    id: id,
                                    rangeNumber: (self.servicePriceRange.count + 1),
                                    lowerRange: lastUpperRange,
                                    upperRange: upperRange,
                                    pricea: modifirea,
                                    priceb: modifireb,
                                    pricec: modifirec
                                ),
                                callback: {
                                    self.removeServiceRange(id: id)
                                }
                            ))
                            
                            Dispatch.asyncAfter(0.2) {
                                _ = JSObject.global.scrollToBottom!( "rangorizadorServicios")
                            }
                            
                        }
                    H3("Rangorizador Servicios").color(.lightBlueText)
                }
                Div().clear(.both).height(3.px)
                Div{
                    Table().noResult(label: "💵 Agregar Rango")
                        .hidden(self.$servicePriceRange.map{ !$0.isEmpty })
                        .height(70.px)
                    
                    ForEach(self.$servicePriceRange){
                        $0
                    }
                    .hidden(self.$servicePriceRange.map{ $0.isEmpty })
                    
                }
                .id(Id(stringLiteral: "rangorizadorServicios"))
                .class(.roundDarkBlue)
                .maxHeight(250.px)
                .minHeight(70.px)
                .overflow(.auto)
                
                Div().clear(.both).height(7.px)
                
                Div{
                    Img()
                        .src("/skyline/media/add.png")
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .cursor(.pointer)
                        .float(.right)
                        .height(18.px)
                        .onClick {
                            
                            let id = UUID()
                            
                            var lastUpperRange: Int64 = 0
                            
                            var upperRange: Int64 = 0
                            
                            var modifirea: Int64 = 0
                            
                            var modifireb: Int64 = 0
                            
                            var modifirec: Int64 = 0
                            
                            if let range = self.productPriceRange.last {
                                
                                guard let _lowerRange = Double( range.lowerRange.replace(from: ",", to: "") ) else {
                                    return
                                }
                                
                                guard let  _upperRange = Double( range.upperRange.replace(from: ",", to: "") ) else {
                                    showError(.errorGeneral, "Incluya rango superior")
                                    range.lowerRangeField.select()
                                    return
                                }
                                
                                guard _upperRange > _lowerRange else {
                                    showError(.errorGeneral, "Rango superior debe ser mayor al rango menor")
                                    return
                                }
                                
                                if range.pricea.isEmpty {
                                    showError(.errorGeneral, "Incluya rango pordentaje a")
                                    range.lowerRangeField.select()
                                    return
                                }
                                
                                if range.priceb.isEmpty {
                                    showError(.errorGeneral, "Incluya rango pordentaje b")
                                    range.lowerRangeField.select()
                                    return
                                }
                                if range.pricec.isEmpty {
                                    showError(.errorGeneral, "Incluya rango pordentaje c")
                                    range.lowerRangeField.select()
                                    return
                                }
                                
                                let _lastUpperRange = (_upperRange + 0.01)
                                
                                lastUpperRange = _lastUpperRange.toCents
                                
                                let newRange = (_lastUpperRange * PriceRanger.getRange(lastRange: lastUpperRange))
                                
                                upperRange = newRange.toCents
                                
                                let base = PriceRanger.getPercentBase(lastRange: lastUpperRange, newRange: upperRange)
                                
                                guard let pricea = Double(range.pricea) else {
                                    return
                                }
                                
                                let newPricea = pricea - (pricea * base)
                                
                                let percents = PriceRanger.getPercentLevels(base: newPricea)
                                
                                modifirea = percents.pricea.toCents
                                modifireb = percents.priceb.toCents
                                modifirec = percents.pricec.toCents
                                
                            }
                            else {
                                
                                upperRange = 500
                                
                                let percents = PriceRanger.getPercentLevels(base: 180.00)
                                
                                modifirea = percents.pricea.toCents
                                modifireb = percents.priceb.toCents
                                modifirec = percents.pricec.toCents
                            }
                            
                            self.lastProductPriceRangeID = id
                            
                            self.productPriceRange.append(.init(
                                rangeNumber: (self.productPriceRange.count + 1),
                                currentLastRange: self.$lastProductPriceRangeID,
                                item: .init(
                                    id: id,
                                    rangeNumber: (self.productPriceRange.count + 1),
                                    lowerRange: lastUpperRange,
                                    upperRange: upperRange,
                                    pricea: modifirea,
                                    priceb: modifireb,
                                    pricec: modifirec
                                ),
                                callback: {
                                    self.removeProductRange(id: id)
                                }
                            ))
                            
                            Dispatch.asyncAfter(0.2) {
                                _ = JSObject.global.scrollToBottom!( "rangorizadorProductos")
                            }
                            
                        }
                    H3("Rangorizador Productos").color(.lightBlueText)
                }
                Div().clear(.both).height(3.px)
                Div{
                    Table().noResult(label: "💵 Agregar Rango")
                        .hidden(self.$productPriceRange.map{ !$0.isEmpty })
                        .height(70.px)
                    
                    ForEach(self.$productPriceRange){
                        $0
                    }
                    .hidden(self.$productPriceRange.map{ $0.isEmpty })
                }
                .id(Id(stringLiteral: "rangorizadorProductos"))
                .class(.roundDarkBlue)
                .maxHeight(250.px)
                .minHeight(70.px)
                .overflow(.auto)
                
                
                Div().height(300.px)
                
            }
            .custom("width", "calc(50% - 7px)")
            .height(100.percent)
            .paddingRight( 3.px)
            .paddingLeft( 3.px)
            .float(.left)
            
            Div{
                
                H3("Sistema de Recompensas").color(.lightBlueText)
                
                /// Sistema de Recompensas
                Div{
                    Div{
                        Label("Sistema de Recompensas")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.rewardsStructureTypeSelect
                    }
                    .class(.oneHalf)
                }
                
                Div{
                    
                    Div().clear(.both).height(3.px)
                    
                    Div(self.$rewardsStructureTypeHelper.map { "Rango de precio preomedio: \($0?.rangeDescription ?? "")" }).color(.white)
                    
                    Div().clear(.both).height(7.px)
                    
                    Div("Puntos para subir de nivel")
                        .color(.lightBlueText)
                        .paddingBottom(3.px)
                    Div{
                        Div{
                            Label("Club")
                                .color(.white)
                            self.rewardsTierClubBreakField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Bronce")
                                .color(.white)
                            self.rewardsTierBronceBreakField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Plata")
                                .color(.white)
                            self.rewardsTierSilverBreakField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Oro")
                                .color(.white)
                            self.rewardsTierGoldBreakField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Diamante")
                                .color(.white)
                            self.rewardsTierDiamondBreakField
                        }
                        .width(20.percent)
                        .float(.left)
                        
                    }
                    Div().clear(.both).height(7.px)
                    
                    Div("% de recompensa productos por nivel")
                        .color(.lightBlueText)
                        .paddingBottom(3.px)
                    
                    Div{
                        Div{
                            Label("Club")
                                .color(.white)
                            self.rewardsPercentProductTierClubField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Bronce")
                                .color(.white)
                            self.rewardsPercentProductTierBronceField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Plata")
                                .color(.white)
                            self.rewardsPercentProductTierSilverField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Oro")
                                .color(.white)
                            self.rewardsPercentProductTierGoldField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Diamante")
                                .color(.white)
                            self.rewardsPercentProductTierDiamondField
                        }
                        .width(20.percent)
                        .float(.left)
                        
                    }
                    Div().clear(.both).height(7.px)
                     
                    Div("% de recompensa servicios por nivel")
                        .color(.lightBlueText)
                        .paddingBottom(3.px)
                    
                    Div{
                        Div{
                            Label("Club")
                                .color(.white)
                            self.rewardsPercentServiceTierClubField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Bronce")
                                .color(.white)
                            self.rewardsPercentServiceTierBronceField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Plata")
                                .color(.white)
                            self.rewardsPercentServiceTierSilverField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Oro")
                                .color(.white)
                            self.rewardsPercentServiceTierGoldField
                        }
                        .width(20.percent)
                        .float(.left)
                        Div{
                            Label("Diamante")
                                .color(.white)
                            self.rewardsPercentServiceTierDiamondField
                        }
                        .width(20.percent)
                        .float(.left)
                        
                    }
                    
                    Div().clear(.both).height(7.px)
                    
                    Div("Recompensa en puntos por referido")
                        .color(.lightBlueText)
                        .paddingBottom(3.px)
                     
                    Div{
                        Div{
                            Label("Nivel 1")
                                .color(.white)
                            self.rewardsRefrenceTierOneField
                        }
                        .width(33.percent)
                        .float(.left)
                        Div{
                            Label("Nivel 2")
                                .color(.white)
                            self.rewardsRefrenceTierTwoField
                        }
                        .width(33.percent)
                        .float(.left)
                        Div{
                            Label("Nivel 3")
                                .color(.white)
                            self.rewardsRefrenceTierThreeField
                        }
                        .width(33.percent)
                        .float(.left)
                        
                    }
                    Div().clear(.both).height(7.px)
                    
                    Div("Inscripción al programa de recompensas")
                        .color(.lightBlueText)
                        .paddingBottom(3.px)
                    Div{
                        
                        Div{
                            Div("Al crear ordenes")
                                .width(50.percent)
                                .color(.white)
                                .float(.left)
                            Div{
                                self.orderOpenInscriptionModeSelect
                            }
                            .width(50.percent)
                            .float(.left)
                        }
                        Div().clear(.both).height(7.px)
                        
                        Div{
                            Div("Al cerrar ordenes")
                                .width(50.percent)
                                .color(.white)
                                .float(.left)
                            Div{
                                self.orderCloseInscriptionModeSelect
                            }
                            .width(50.percent)
                            .float(.left)
                        }
                        Div().clear(.both).height(7.px)
                    
                        Div{
                            Div("En el punto de venta")
                                .width(50.percent)
                                .color(.white)
                                .float(.left)
                            Div{
                                self.pointOfSaleCloseInscriptionModeModeSelect
                            }
                            .width(50.percent)
                            .float(.left)
                        }
                        Div().clear(.both).height(7.px)
                    
                        
                        Div{
                            Div("Al crear cuenta")
                                .width(50.percent)
                                .color(.white)
                                .float(.left)
                            Div{
                                self.newAccountCloseInscriptionModeModeSelect
                            }
                            .width(50.percent)
                            .float(.left)
                        }
                        Div().clear(.both).height(7.px)
                        
                    }
                    
                    Div().clear(.both).height(7.px)
                    
                    /// Welcome Gift
                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .padding(all: 3.px)
                            .paddingRight(0.px)
                            .cursor(.pointer)
                            .float(.right)
                            .height(18.px)
                            .onClick {
                                addToDom(RewadsAddWelcomeGift(currentGifts: self.welcomeGift){ item in
                                    self.welcomeGift.append(item)
                                })
                            }
                        H3("Regalo de bienvenida").color(.lightBlueText)
                    }
                    Div().clear(.both).height(3.px)
                    Div{
                        Table().noResult(label: "⭐️ Agregar Recompensa")
                            .hidden(self.$welcomeGift.map{ !$0.isEmpty })
                            .height(70.px)
                        self.welcomeGiftDiv
                            .hidden(self.$welcomeGift.map{ $0.isEmpty })
                    }
                    .class(.roundDarkBlue)
                    .minHeight(70.px)
                     
                    /// Level 1
                    Div{
                        Div{
                            
                            Img()
                                .src("/skyline/media/add.png")
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .cursor(.pointer)
                                .float(.right)
                                .height(18.px)
                                .onClick {
                                    
                                    var items: [RewardsProgramItems] = []
                                    
                                    items.append(contentsOf: self.rewardsTierClubItems)
                                    items.append(contentsOf: self.rewardsTierBronceItems)
                                    items.append(contentsOf: self.rewardsTierSilverItems)
                                    items.append(contentsOf: self.rewardsTierGoldItems)
                                    items.append(contentsOf: self.rewardsTierDiamondItems)
                                    
                                    addToDom(RewadsAddTierReward(currentRewardsItems: items){ item in
                                        self.rewardsTierClubItems.append(item)
                                    })
                                    
                                }
                            
                            H3("Recompensas Club").color(.lightBlueText)
                        }
                        Div().clear(.both).height(3.px)
                        
                        Div{
                            Table().noResult(label: "⭐️ Agregar Recompensa")
                                .hidden(self.$rewardsTierClubItems.map{ !$0.isEmpty })
                                .height(70.px)
                            self.rewardsTierClubItemsDiv
                                .hidden(self.$rewardsTierClubItems.map{ $0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .minHeight(70.px)
                         
                    }
                    .hidden(self.$rewardsStructureTypeHelper.map{ ![
                        RewardsProgramType.highTicket,
                        RewardsProgramType.premiumTicket,
                        RewardsProgramType.highPremiumTicket
                    ].contains($0) || $0 == nil})
                     
                    /// level 2
                    Div{
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .cursor(.pointer)
                                .float(.right)
                                .height(18.px)
                                .onClick {
                                    
                                    var items: [RewardsProgramItems] = []
                                    
                                    items.append(contentsOf: self.rewardsTierClubItems)
                                    items.append(contentsOf: self.rewardsTierBronceItems)
                                    items.append(contentsOf: self.rewardsTierSilverItems)
                                    items.append(contentsOf: self.rewardsTierGoldItems)
                                    items.append(contentsOf: self.rewardsTierDiamondItems)
                                    
                                    addToDom(RewadsAddTierReward(currentRewardsItems: items){ item in
                                        self.rewardsTierBronceItems.append(item)
                                    })
                                }
                            H3("Recompensas Bronce").color(.lightBlueText)
                        }
                        Div().clear(.both).height(3.px)
                        Div{
                            Table().noResult(label: "⭐️ Agregar Recompensa")
                                .hidden(self.$rewardsTierBronceItems.map{ !$0.isEmpty })
                                .height(70.px)
                            self.rewardsTierBronceItemsDiv
                                .hidden(self.$rewardsTierBronceItems.map{ $0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .minHeight(70.px)
                    }
                    .hidden(self.$rewardsStructureTypeHelper.map{ ![
                        RewardsProgramType.highTicket,
                        RewardsProgramType.premiumTicket,
                        RewardsProgramType.highPremiumTicket
                    ].contains($0) || $0 == nil })
                     
                    /// Level 3
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .cursor(.pointer)
                                .float(.right)
                                .height(18.px)
                                .onClick {
                                    
                                    var items: [RewardsProgramItems] = []
                                    
                                    items.append(contentsOf: self.rewardsTierClubItems)
                                    items.append(contentsOf: self.rewardsTierBronceItems)
                                    items.append(contentsOf: self.rewardsTierSilverItems)
                                    items.append(contentsOf: self.rewardsTierGoldItems)
                                    items.append(contentsOf: self.rewardsTierDiamondItems)
                                    
                                    addToDom(RewadsAddTierReward(currentRewardsItems: items){ item in
                                        self.rewardsTierSilverItems.append(item)
                                    })
                                }
                            H3("Recompensas Plata").color(.lightBlueText)
                        }
                        Div().clear(.both).height(3.px)
                        Div{
                            Table().noResult(label: "⭐️ Agregar Recompensa")
                                .hidden(self.$rewardsTierSilverItems.map{ !$0.isEmpty })
                                .height(70.px)
                            self.rewardsTierSilverItemsDiv
                                .hidden(self.$rewardsTierSilverItems.map{ $0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .minHeight(70.px)
                        
                    }
                    .hidden(self.$rewardsStructureTypeHelper.map{ ![
                        RewardsProgramType.highTicket,
                        RewardsProgramType.premiumTicket,
                        RewardsProgramType.highPremiumTicket
                    ].contains($0) || $0 == nil })
                     
                    /// Level 4
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .cursor(.pointer)
                                .float(.right)
                                .height(18.px)
                                .onClick {
                                    
                                    var items: [RewardsProgramItems] = []
                                    
                                    items.append(contentsOf: self.rewardsTierClubItems)
                                    items.append(contentsOf: self.rewardsTierBronceItems)
                                    items.append(contentsOf: self.rewardsTierSilverItems)
                                    items.append(contentsOf: self.rewardsTierGoldItems)
                                    items.append(contentsOf: self.rewardsTierDiamondItems)
                                    
                                    addToDom(RewadsAddTierReward(currentRewardsItems: items){ item in
                                        self.rewardsTierGoldItems.append(item)
                                    })
                                }
                            H3("Recompensas Oro").color(.lightBlueText)
                        }
                        Div().clear(.both).height(3.px)
                        Div{
                            Table().noResult(label: "⭐️ Agregar Recompensa")
                                .hidden(self.$rewardsTierGoldItems.map{ !$0.isEmpty })
                                .height(70.px)
                            self.rewardsTierGoldItemsDiv
                                .hidden(self.$rewardsTierGoldItems.map{ $0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .minHeight(70.px)
                        
                    }
                    .hidden(self.$rewardsStructureTypeHelper.map{ ![
                        RewardsProgramType.premiumTicket,
                        RewardsProgramType.highPremiumTicket
                    ].contains($0) || $0 == nil })
                     
                    /// Level 5
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .cursor(.pointer)
                                .float(.right)
                                .height(18.px)
                                .onClick {
                                    
                                    var items: [RewardsProgramItems] = []
                                    
                                    items.append(contentsOf: self.rewardsTierClubItems)
                                    items.append(contentsOf: self.rewardsTierBronceItems)
                                    items.append(contentsOf: self.rewardsTierSilverItems)
                                    items.append(contentsOf: self.rewardsTierGoldItems)
                                    items.append(contentsOf: self.rewardsTierDiamondItems)
                                    
                                    addToDom(RewadsAddTierReward(currentRewardsItems: items){ item in
                                        self.rewardsTierDiamondItems.append(item)
                                    })
                                }
                            H3("Recompensas Platino").color(.lightBlueText)
                        }
                        Div().clear(.both).height(3.px)
                        Div{
                            Table().noResult(label: "⭐️ Agregar Recompensa")
                                .hidden(self.$rewardsTierDiamondItems.map{ !$0.isEmpty })
                                .height(70.px)
                            self.rewardsTierDiamondItemsDiv
                                .hidden(self.$rewardsTierDiamondItems.map{ $0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .minHeight(70.px)
                        
                    }
                    .hidden(self.$rewardsStructureTypeHelper.map{ ![
                        RewardsProgramType.highPremiumTicket
                    ].contains($0) || $0 == nil })
                    
                }
                .hidden(self.$rewardsStructureTypeHelper.map { $0 == nil })
                 
                H3("Citas y recordatorios").color(.lightBlueText)
                
                /// Enviar `recordatorios`, ordens pendientes de entrega
                Div{
                    Div{
                        Label("Enviar recordatorios, ordens pendientes de entrega")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.orderPendingPickupLimitAlertCheckbox
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// A que dias el sistema enviara recordatorio pendientes de entrega
                Div{
                    Div{
                        Label("A que dias el sistema enviara recordatorio pendientes de entrega")
                            .color(.lightGray)
                    }
                    .width(80.percent)
                    .float(.left)
                    Div{
                        self.orderPendingPickupLimitStartField
                    }
                    .width(20.percent)
                    .float(.left)
                }
                Div().clear(.both).height(7.px)
                 
                /// Cada cuantos dias el sistema enviara recordatorio pendientes de entrega
                Div{
                    Div{
                        Label("Cada cuantos dias el sistema enviara recordatorio pendientes de entrega")
                            .color(.lightGray)
                    }
                    .width(80.percent)
                    .float(.left)
                    Div{
                        self.orderPendingPickupLimitEveryWhenField
                    }
                    .width(20.percent)
                    .float(.left)
                }
                Div().clear(.both).height(7.px)
                
                /// A que dias el sistema cesaran recordatorios pendientes de entrega
                Div{
                    Div{
                        Label("A que dias el sistema cesaran recordatorios pendientes de entrega")
                            .color(.lightGray)
                    }
                    .width(80.percent)
                    .float(.left)
                    Div{
                        self.orderPendingPickupLimitEndField
                    }
                    .width(20.percent)
                    .float(.left)
                }
                Div().clear(.both).height(7.px)
                
                /// Mensaje generico de recordatorio de equipo pendiente de entrega
                Div{
                    Div{
                        Label("Recordatorio generico de pendiente de entrega")
                            .color(.lightGray)
                    }
                    .marginBottom(3.px)
                    
                    Div{
                        self.orderPendingPickupLimitEveryWhenMsgTextArea
                    }
                }
                Div().clear(.both).height(7.px)
                 
                /// Alerta de 3 dias expiracion de equipo pendiente de entrega
                Div{
                    Div{
                        Label("Alerta de 3 dias perdida de pendiente de entrega")
                            .color(.lightGray)
                    }
                    .marginBottom(3.px)
                    Div{
                        self.orderPendingPickupLimitThreeDayAlertMsgTextArea
                    }
                }
                Div().clear(.both).height(7.px)
                
                /// Alerta de 1 dias expiracion de equipo pendiente de entrega
                Div{
                    Div{
                        Label("Alerta de 1 dias perdida de pendiente de entrega")
                            .color(.lightGray)
                    }
                    .marginBottom(3.px)
                    Div{
                        self.orderPendingPickupLimitOneDayAlertMsgTextArea
                    }
                }
                Div().clear(.both).height(7.px)
                
                /// Alerta de 0 dias expiracion de equipo pendiente de entrega
                Div{
                    Div{
                        Label("Alerta de 0 dias expiracion de equipo pendiente de entrega")
                            .color(.lightGray)
                    }
                    .marginBottom(3.px)
                    Div{
                        self.orderPendingPickupLimitZeroDayAlertMsgTextArea
                    }
                }
                Div().clear(.both).height(7.px)
                 
                Div{
                    Div{
                        Label("Contrato de Prestacion de Servicios")
                            .color(.lightGray)
                    }
                    .marginBottom(3.px)
                    Div{
                        self.orderContractTextArea
                    }
                }
                Div().clear(.both).height(7.px)
                
                H3("Manejo de Inventario en venta / orden").color(.lightBlueText)
                
                /// Agragar/ Remover Inventario de `orden`:
                Div{
                    Div{
                        Label("Agragar/ Remover Inventario de orden:")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.orderAddedProductDeliverySelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Agragar/ Remover Inventario de `venta`:
                Div{
                    Div{
                        Label("Agragar/ Remover Inventario de venta:")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.saleProductDeliverySelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                 
                H3("Membresias / Creditos y Cobranzas (predertemiados)").color(.lightBlueText)
                
                /// Tipo de credito por defecto
                Div{
                    Div{
                        Label("Tipo de credito")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.creditTypeSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Fecha de facturación por defecto
                Div{
                    Div{
                        Label("Fecha de facturación")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.billingDateField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                 
                /// Días de Credito
                Div{
                    Div{
                        Label("Días de Credito")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.creditDaysField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Limite de Credito
                Div{
                    Div{
                        Label("Limite de credito")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    Div{
                        self.initialCreditLimitField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                Div().height(300.px)
                
            }
            .custom("width", "calc(50% - 7px)")
            .height(100.percent)
            .paddingRight( 3.px)
            .paddingLeft( 3.px)
            .float(.left)
            
            Div("Guardar Cambios")
                .border(width: .thin, style: .solid, color: .darkGray)
                .custom("box-shadow", "1px 1px 28px #000000")
                .class(.uibtnLargeOrange)
                .position(.absolute)
                .bottom(12.px)
                .right(12.px)
                .onClick {
                    self.saveData()
                }
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            height(100.percent)
            
            ConfigConfigContactTagsInstitudType.allCases.forEach { type in
                instituteTagSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            /// `gridViewSelect`
            CustOrderGridView.allCases.forEach { view in
                gridViewSelect.appendChild(
                    Option(view.description)
                        .value(view.rawValue)
                )
            }
            
            ConfigConfigContactTagsCustomerType.allCases.forEach { type in
                customerTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            /// `accountMobileConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                accountMobileConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `accountIdConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                accountIdConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `orderMobileConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                orderMobileConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `rentalMobileConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                rentalMobileConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `dateMobileConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                dateMobileConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `orderIdConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                orderIdConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `rentalIdConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                rentalIdConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `dateIdConfirmationModeSelect`
            ConfirmationMode.allCases.forEach { mode in
                dateIdConfirmationModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `createPersonalAccountModeSelect`
            CreateAccountMode.allCases.forEach { mode in
                createPersonalAccountModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `createBuisnessAccountMode`
            CreateAccountMode.allCases.forEach { mode in
                createBuisnessAccountModeSelect.appendChild(
                    Option(mode.description)
                        .value(mode.rawValue)
                )
            }
            
            /// `creditTypeSelect`
            StoreCreditType.allCases.forEach { type in
                creditTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            /// `currencySelect`
            Currencies.allCases.forEach { currency in
                currencySelect.appendChild(
                    Option(currency.description)
                        .value(currency.rawValue)
                )
            }
            
            ProductDeliveryType.allCases.forEach { type in
                orderAddedProductDeliverySelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
                saleProductDeliverySelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
           
            /// `restrictOrderCreationSelect`
            UsernameRoles.allCases.forEach { role in
                restrictOrderCreationSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `restrictOrderClosingSelect`
            UsernameRoles.allCases.forEach { role in
                restrictOrderClosingSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `restrictOrderChargesSelect`
            UsernameRoles.allCases.forEach { role in
                restrictOrderChargesSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `restrictSaleChargesSelect`
            UsernameRoles.allCases.forEach { role in
                restrictSaleChargesSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `restrictMermProductSelect`
            UsernameRoles.allCases.forEach { role in
                restrictMermProductSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `restrictDeleteChargesSelect`
            UsernameRoles.allCases.forEach { role in
                restrictDeleteChargesSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `restrictDeletePaymentsSelect`
            UsernameRoles.allCases.forEach { role in
                restrictDeletePaymentsSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `restrictDeleteFiscalSelect`
            UsernameRoles.allCases.forEach { role in
                restrictDeleteFiscalSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
               
            }
            
            /// `openFiscalInvoceSelect`
            UsernameRoles.allCases.forEach { role in
                openFiscalInvoceSelect.appendChild(
                   Option(role.description)
                    .value(role.value.toString)
               )
            }
            
            rewardsStructureTypeSelect.appendChild(Option("Seleccione Opcion").value(""))
            
            RewardsProgramType.allCases.forEach { type in
                rewardsStructureTypeSelect.appendChild(
                    Option(type.description).value(type.rawValue)
                )
            }
            
            ConfirmationMode.allCases.forEach { item in
                orderOpenInscriptionModeSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
            }
            
            ConfirmationMode.allCases.forEach { item in
                orderCloseInscriptionModeSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
            }
            
            ConfirmationMode.allCases.forEach { item in
                pointOfSaleCloseInscriptionModeModeSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
            }
            
            ConfirmationMode.allCases.forEach { item in
                newAccountCloseInscriptionModeModeSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
            }
            
            SerializationSequenceType.allCases.forEach { item in
                saleSerializationSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
                orderSerializationSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
                fiscalSerializationSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
            }
            
            self.$creditRequisitObject.listen {
                
            }
            
            $rewardsStructureType.listen {
                self.rewardsStructureTypeHelper = RewardsProgramType(rawValue: $0) ?? .lowTicket
                self.rewardsTierClubItems = []
                self.rewardsTierBronceItems = []
                self.rewardsTierSilverItems = []
                self.rewardsTierGoldItems = []
                self.rewardsTierDiamondItems = []
            }
            
            self.$welcomeGift.listen {
                self.welcomeGiftDiv.innerHTML = ""
                
                $0.forEach { item in
                    
                    var helpText = ""
                    
                    let itemid: UUID = .init()
                    
                    switch item {
                    case .freePoints(let points):
                        helpText = points.toString
                    }
                    
                    let view = Div{
                        
                        Div{
                            Span(helpText)
                                .float(.right)
                            
                            Span(item.description)
                                .float(.left)
                            
                        }
                        .custom("width", "calc(100% - 50px)")
                        .float(.left)
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .margin(all: 7.px)
                                .height(18.px)
                                .onClick {
                                    
                                    self.welcomeGift = []
                                    
                                    self.rewardsViewRefrence[itemid]?.remove()
                                    
                                    self.rewardsViewRefrence.removeValue(forKey: itemid)
                                    
                                }
                        }
                        .width(50.px)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                        .marginBottom(7.px)
                        .width(95.percent)
                        .class(.uibtn)
                    
                    self.welcomeGiftDiv.appendChild(view)
                    
                    
                    self.rewardsViewRefrence[itemid] = view
                }
            }

            self.$rewardsTierClubItems.listen {
                self.rewardsTierClubItemsDiv.innerHTML = ""
                $0.forEach { item in
                    
                    let itemid: UUID = .init()
                    
                    let view = Div{
                        
                        Div{
                            
                            H3(item.description)
                                .color(.white)
                                .float(.left)
                            
                            Div()
                                .marginBottom(3.px)
                                .clear(.both)
                            
                            Div(item.helpText)
                                .fontSize(18.px)
                                .color(.gray)
                        }
                        .custom("width", "calc(100% - 50px)")
                        .float(.left)
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .margin(all: 7.px)
                                .height(18.px)
                                .onClick {
                                    
                                    var newitems: [RewardsProgramItems] = []
                                    
                                    self.rewardsTierClubItems.forEach { _item in
                                        
                                        if item == _item {
                                            return
                                        }
                                        
                                        newitems.append(_item)
                                        
                                    }
                                    
                                    self.rewardsTierClubItems = newitems
                                    
                                    self.rewardsViewRefrence[itemid]?.remove()
                                    
                                    self.rewardsViewRefrence.removeValue(forKey: itemid)
                                    
                                }
                        }
                        .width(50.px)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                        .marginBottom(7.px)
                        .width(95.percent)
                        .class(.uibtn)
                    
                    self.rewardsTierClubItemsDiv.appendChild(view)
                }
            }

            self.$rewardsTierBronceItems.listen {
                self.rewardsTierBronceItemsDiv.innerHTML = ""
                $0.forEach { item in
                    
                    let itemid: UUID = .init()
                    
                    let view = Div{
                        
                        Div{
                            
                            H3(item.description)
                                .color(.white)
                                .float(.left)
                            
                            Div()
                                .marginBottom(3.px)
                                .clear(.both)
                            
                            Div(item.helpText)
                                .fontSize(18.px)
                                .color(.gray)
                            
                        }
                        .custom("width", "calc(100% - 50px)")
                        .float(.left)
                            
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .margin(all: 7.px)
                                .height(18.px)
                                .onClick {
                                    
                                    var newitems: [RewardsProgramItems] = []
                                    
                                    self.rewardsTierBronceItems.forEach { _item in
                                        
                                        if item == _item {
                                            return
                                        }
                                        
                                        newitems.append(_item)
                                        
                                    }
                                    
                                    self.rewardsTierBronceItems = newitems
                                    
                                    self.rewardsViewRefrence[itemid]?.remove()
                                    
                                    self.rewardsViewRefrence.removeValue(forKey: itemid)
                                    
                                }
                        }
                        .width(50.px)
                        .float(.left)
                        
                        Div().clear(.both)
                    }
                        .marginBottom(7.px)
                        .width(95.percent)
                        .class(.uibtn)
                    
                    self.rewardsTierBronceItemsDiv.appendChild(view)
                }
            }

            self.$rewardsTierSilverItems.listen {
                self.rewardsTierSilverItemsDiv.innerHTML = ""
                $0.forEach { item in
                    
                    let itemid: UUID = .init()
                    
                    let view = Div{
                        Div{
                            
                            H3(item.description)
                                .color(.white)
                                .float(.left)
                            
                            Div()
                                .marginBottom(3.px)
                                .clear(.both)
                            
                            Div(item.helpText)
                                .fontSize(18.px)
                                .color(.gray)
    
                        }
                        .custom("width", "calc(100% - 50px)")
                        .float(.left)
                            
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .margin(all: 7.px)
                                .height(18.px)
                                .onClick {
                                    
                                    var newitems: [RewardsProgramItems] = []
                                    
                                    self.rewardsTierSilverItems.forEach { _item in
                                        
                                        if item == _item {
                                            return
                                        }
                                        
                                        newitems.append(_item)
                                        
                                    }
                                    
                                    self.rewardsTierSilverItems = newitems
                                    
                                    self.rewardsViewRefrence[itemid]?.remove()
                                    
                                    self.rewardsViewRefrence.removeValue(forKey: itemid)
                                    
                                }
                        }
                        .width(50.px)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                    .marginBottom(7.px)
                    .width(95.percent)
                    .class(.uibtn)

                    self.rewardsTierSilverItemsDiv.appendChild(view)
                }
            }

            self.$rewardsTierGoldItems.listen {
                self.rewardsTierGoldItemsDiv.innerHTML = ""
                $0.forEach { item in
                    
                    let itemid: UUID = .init()
                    
                    let view = Div{
                        
                        Div{
                            H3(item.description)
                                .color(.white)
                                .float(.left)
                            
                            Div()
                                .marginBottom(3.px)
                                .clear(.both)
                            
                            Div(item.helpText)
                                .fontSize(18.px)
                                .color(.gray)
                        }
                        .custom("width", "calc(100% - 50px)")
                        .float(.left)
                            
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .margin(all: 7.px)
                                .height(18.px)
                                .onClick {
                                    
                                    var newitems: [RewardsProgramItems] = []
                                    
                                    self.rewardsTierGoldItems.forEach { _item in
                                        
                                        if item == _item {
                                            return
                                        }
                                        
                                        newitems.append(_item)
                                        
                                    }
                                    
                                    self.rewardsTierGoldItems = newitems
                                    
                                    self.rewardsViewRefrence[itemid]?.remove()
                                    
                                    self.rewardsViewRefrence.removeValue(forKey: itemid)
                                    
                                }
                        }
                        .width(50.px)
                        .float(.left)
                        
                        Div().clear(.both)
                    }
                        .marginBottom(7.px)
                        .width(95.percent)
                        .class(.uibtn)
                    
                    self.rewardsTierGoldItemsDiv.appendChild(view)
                }
            }

            self.$rewardsTierDiamondItems.listen {
                self.rewardsTierDiamondItemsDiv.innerHTML = ""
                $0.forEach { item in
                    
                    let itemid: UUID = .init()
                    
                    let view = Div{
                        
                        Div{
                            
                            H3(item.description)
                                .color(.white)
                                .float(.left)
                            
                            Div()
                                .marginBottom(3.px)
                                .clear(.both)
                            
                            Div(item.helpText)
                                .fontSize(18.px)
                                .color(.gray)
                            
                        }
                        .custom("width", "calc(100% - 50px)")
                        .float(.left)
                            
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .margin(all: 7.px)
                                .height(18.px)
                                .onClick {
                                    
                                    var newitems: [RewardsProgramItems] = []
                                    
                                    self.rewardsTierDiamondItems.forEach { _item in
                                        
                                        if item == _item {
                                            return
                                        }
                                        
                                        newitems.append(_item)
                                        
                                    }
                                    
                                    self.rewardsTierDiamondItems = newitems
                                    
                                    self.rewardsViewRefrence[itemid]?.remove()
                                    
                                    self.rewardsViewRefrence.removeValue(forKey: itemid)
                                    
                                }
                        }
                        .width(50.px)
                        .float(.left)
                        
                        Div().clear(.both)
                    }
                        .marginBottom(7.px)
                        .width(95.percent)
                        .class(.uibtn)
                    
                    self.rewardsTierDiamondItemsDiv.appendChild(view)
                    
                }
            }
            
            getUsers(storeid: nil, onlyActive: true) { users in
                
                users.forEach { user in
                    
                    self.operationalContactSelect.appendChild(
                        Option(user.username)
                            .value(user.id.uuidString)
                    )
                    
                    self.salesContactSelect.appendChild(
                        Option(user.username)
                            .value(user.id.uuidString)
                    )
                    
                    self.finacialContactSelect.appendChild(
                        Option(user.username)
                            .value(user.id.uuidString)
                    )
                    
                }
                
                self.loadConfiguration(
                    configStoreProcessing: self.configStoreProcessing,
                    configContactTags: self.configContactTags
                )
            }
            
        }
        
        func loadConfiguration(configStoreProcessing: ConfigStoreProcessing, configContactTags: ConfigContactTags){
            
            print("🟢  loadConfiguration")
            
            /// ⚠️  `ConfigStoreProcessing`
            
            self.moduleProfile = configStoreProcessing.moduleProfile
            
            self.moduleProfileOrder = configStoreProcessing.moduleProfile.contains(.order)
            
            self.moduleProfileRental = configStoreProcessing.moduleProfile.contains(.rental)
            
            self.moduleProfileDate = configStoreProcessing.moduleProfile.contains(.date)
            
            self.gridView = configStoreProcessing.gridView.rawValue
            
            self.accountMobileConfirmationMode = configStoreProcessing.accountMobileConfirmationMode.rawValue
            
            self.accountIdConfirmationMode = configStoreProcessing.accountIdConfirmationMode.rawValue
            
            self.orderMobileConfirmationMode = configStoreProcessing.orderMobileConfirmationMode.rawValue
            
            self.rentalMobileConfirmationMode = configStoreProcessing.rentalMobileConfirmationMode.rawValue
            
            self.dateMobileConfirmationMode = configStoreProcessing.dateMobileConfirmationMode.rawValue
            
            self.orderIdConfirmationMode = configStoreProcessing.orderIdConfirmationMode.rawValue
            
            self.rentalIdConfirmationMode = configStoreProcessing.rentalIdConfirmationMode.rawValue
            
            self.dateIdConfirmationMode = configStoreProcessing.dateIdConfirmationMode.rawValue
            
            self.createPersonalAccountMode = configStoreProcessing.createPersonalAccountMode.rawValue
            
            self.createBuisnessAccountMode = configStoreProcessing.createBuisnessAccountMode.rawValue
            
            self.currency = configStoreProcessing.currency.rawValue
            
            self.restrictOrderCreation = configStoreProcessing.restrictOrderCreation.toString
            
            self.restrictOrderClosing = configStoreProcessing.restrictOrderClosing.toString
            
            self.restrictOrderCharges = configStoreProcessing.restrictOrderCharges.toString
            
            self.restrictSaleCharges = configStoreProcessing.restrictSaleCharges.toString
            
            self.restrictMermProduct = configStoreProcessing.restrictMermProduct.toString
            
            self.restrictDeleteCharges = configStoreProcessing.restrictDeleteCharges.toString
            
            self.restrictDeletePayments = configStoreProcessing.restrictDeletePayments.toString
            
            self.restrictDeleteFiscal = configStoreProcessing.restrictDeleteFiscal.toString
            
            self.autoDeleteCTAM = configStoreProcessing.autoDeleteCTAM.toString
            
            self.openFiscalInvoce = configStoreProcessing.openFiscalInvoce.toString
            
            self.generalComision = configStoreProcessing.generalComision.fromCents.toString
            
            
            
            self.viewPricesOnWeb = true//configStoreProcessing.viewPricesOnWeb
            
            self.varialPricesDisclosure = true//configStoreProcessing.varialPricesDisclosure
            
            self.lastServicePriceRangeID = configStoreProcessing.servicePriceRange.last?.id
            
            print("🟢  configStoreProcessing.servicePriceRange.count \(configStoreProcessing.servicePriceRange.count)")
            
            configStoreProcessing.servicePriceRange.forEach { range in
                self.servicePriceRange.append(.init(
                    rangeNumber: (self.servicePriceRange.count + 1),
                    currentLastRange: self.$lastServicePriceRangeID,
                    item: range,
                    callback: {
                        self.removeServiceRange(id: range.id)
                    }
                ))
            }
            
            self.lastProductPriceRangeID = configStoreProcessing.productPriceRange.last?.id
            
            print("🟢  configStoreProcessing.productPriceRange.count \(configStoreProcessing.productPriceRange.count)")
            
            configStoreProcessing.productPriceRange.forEach { range in
                self.productPriceRange.append(.init(
                    rangeNumber: (self.productPriceRange.count + 1),
                    currentLastRange: self.$lastProductPriceRangeID,
                    item: range,
                    callback: {
                        self.removeProductRange(id: range.id)
                    }
                ))
            }
            
            self.orderDateReminderMorning = configStoreProcessing.orderDateReminderMorning
            
            self.orderDateReminderConcurring = configStoreProcessing.orderDateReminderConcurring
            
            self.orderDateReminderAssistedOperator = configStoreProcessing.orderDateReminderAssistedOperator
            
            self.orderPendingPickupLimitAlert = configStoreProcessing.orderPendingPickupLimitAlert
            
            self.orderPendingPickupLimitStart = configStoreProcessing.orderPendingPickupLimitStart.toString
            
            self.orderPendingPickupLimitEnd = configStoreProcessing.orderPendingPickupLimitEnd.toString
            
            self.orderPendingPickupLimitEveryWhen = configStoreProcessing.orderPendingPickupLimitEveryWhen.toString
            
            self.orderPendingPickupLimitEveryWhenMsg = configStoreProcessing.orderPendingPickupLimitEveryWhenMsg
            
            self.orderPendingPickupLimitThreeDayAlertMsg = configStoreProcessing.orderPendingPickupLimitThreeDayAlertMsg
            
            self.orderPendingPickupLimitOneDayAlertMsg = configStoreProcessing.orderPendingPickupLimitOneDayAlertMsg
            
            self.orderPendingPickupLimitZeroDayAlertMsg = configStoreProcessing.orderPendingPickupLimitZeroDayAlertMsg
            
            self.orderContract = configStoreProcessing.orderContract
            
            self.orderAddedProductDelivery = configStoreProcessing.orderAddedProductDelivery.rawValue
           
            self.saleProductDelivery = configStoreProcessing.saleProductDelivery.rawValue
            
            self.creditType = configStoreProcessing.creditType.rawValue
            
            self.billingDate = configStoreProcessing.billingDate.toString
            
            self.creditDays = configStoreProcessing.creditDays.toString
            
            self.initialCreditLimit = configStoreProcessing.initialCreditLimit.fromCents.toString
            
            self.creditRequisitObject = configStoreProcessing.creditRequisitObject
            
            self.saleSerialization = configStoreProcessing.saleSerialization.rawValue

            self.orderSerialization = configStoreProcessing.orderSerialization.rawValue
            
            self.fiscalSerialization = configStoreProcessing.fiscalSerialization.rawValue
            
            if let rewards = configStoreProcessing.rewardsPrograme {
                
                self.rewardsStructureType = rewards.structureType.rawValue
                
                self.rewardsStructureTypeHelper = rewards.structureType
                
                self.rewardsTierClubBreak = rewards.tierClubBreak.toString
                
                self.rewardsTierBronceBreak = rewards.tierBronceBreak.fromCents.toString
                
                self.rewardsTierSilverBreak = rewards.tierSilverBreak.fromCents.toString
                
                self.rewardsTierGoldBreak = rewards.tierGoldBreak.fromCents.toString
                
                self.rewardsTierDiamondBreak = rewards.tierDiamondBreak.fromCents.toString
                
                self.rewardsPercentProductTierClub = rewards.percentProductTierClub.toString
                
                self.rewardsPercentProductTierBronce = rewards.percentProductTierBronce.toString
                
                self.rewardsPercentProductTierSilver = rewards.percentProductTierSilver.toString
                
                self.rewardsPercentProductTierGold = rewards.percentProductTierGold.toString
                
                self.rewardsPercentProductTierDiamond = rewards.percentProductTierDiamond.toString
                
                self.rewardsPercentServiceTierClub = rewards.percentServiceTierClub.toString
                
                self.rewardsPercentServiceTierBronce = rewards.percentServiceTierBronce.toString
                
                self.rewardsPercentServiceTierSilver = rewards.percentServiceTierSilver.toString
                
                self.rewardsPercentServiceTierGold = rewards.percentServiceTierGold.toString
                
                self.rewardsPercentServiceTierDiamond = rewards.percentServiceTierDiamond.toString
                
                self.rewardsRefrenceTierOne = rewards.refrenceTierOne.fromCents.toString
                
                self.rewardsRefrenceTierTwo = rewards.refrenceTierTwo.fromCents.toString
                
                self.rewardsRefrenceTierThree = rewards.refrenceTierThree.fromCents.toString
                
                
                print("⭐️  rewards.orderOpenInscriptionMode \(rewards.orderOpenInscriptionMode)")
                print("⭐️  rewards.orderCloseInscriptionMode \(rewards.orderCloseInscriptionMode)")
                print("⭐️  rewards.pointOfSaleCloseInscriptionMode \(rewards.pointOfSaleCloseInscriptionMode)")
                print("⭐️  rewards.newAccountCloseInscriptionMode \(rewards.newAccountCloseInscriptionMode)")
                
                self.orderOpenInscriptionMode = rewards.orderOpenInscriptionMode.rawValue
                           
                self.orderCloseInscriptionMode = rewards.orderCloseInscriptionMode.rawValue
                
                self.pointOfSaleCloseInscriptionMode = rewards.pointOfSaleCloseInscriptionMode.rawValue
                
                self.newAccountCloseInscriptionMode = rewards.newAccountCloseInscriptionMode.rawValue
                
                
                self.welcomeGift = rewards.welcomeGift
                
                self.rewardsTierClubItems = rewards.tierClubItems
                
                self.rewardsTierBronceItems = rewards.tierBronceItems
                
                self.rewardsTierSilverItems = rewards.tierSilverItems
                
                self.rewardsTierGoldItems = rewards.tierGoldItems
                
                self.rewardsTierDiamondItems = rewards.tierDiamondItems
                
                
                
            }
            
            /// ⚠️  `ConfigContactTags`
            
            self.requireInstituteTag = configContactTags.requireInstituteTag
            
            self.instituteTag = configContactTags.instituteTag.rawValue
            
            self.customerType = configContactTags.customerType.rawValue
            
            self.requierServiceAddress = configContactTags.requierServiceAddress
            
            self.requierMailingAddrees = configContactTags.requierMailingAddrees
            
            self.requirePhysicalAddress = configContactTags.requirePhysicalAddress
            
            self.operationalContact = configContactTags.operationalContact.uuidString
            
            self.salesContact = configContactTags.salesContact.uuidString
            
            self.finacialContact = configContactTags.finacialContact.uuidString
            
            self.sendNewBusinessAccountComunication = configContactTags.sendNewBusinessAccountComunication
            
        }
        
        func removeProductRange(id: UUID){
            productPriceRange.removeLast()
            lastProductPriceRangeID = productPriceRange.last?.id
        }
        
        func removeServiceRange(id: UUID){
            servicePriceRange.removeLast()
            lastServicePriceRangeID = servicePriceRange.last?.id
        }
        
        func saveData(){
            
            var _moduleProfile: [CustOrderProfiles] = []
            
            if moduleProfileOrder {
                _moduleProfile.append(.order)
            }
            
            if moduleProfileRental {
                _moduleProfile.append(.rental)
            }
            
            if moduleProfileDate {
                _moduleProfile.append(.date)
            }
            
            guard let gridView = CustOrderGridView(rawValue: gridView) else {
                showError(.campoInvalido, "Error al establecer GRID VIEW. Contacte a Soporte TC")
                return
            }
            
            guard let accountMobileConfirmationMode = ConfirmationMode(rawValue: accountMobileConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer ACCT MOBILE CONF. Contacte a Soporte TC")
                return
            }
            
            guard let accountIdConfirmationMode = ConfirmationMode(rawValue: accountIdConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer ACCT ID CONF. Contacte a Soporte TC")
                return
            }
            
            guard let orderMobileConfirmationMode = ConfirmationMode(rawValue: orderMobileConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer ORDR MOBILE CON. Contacte a Soporte TC")
                return
            }
            
            guard let orderIdConfirmationMode = ConfirmationMode(rawValue: orderIdConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer ORDR ID CONF. Contacte a Soporte TC")
                return
            }
            guard let rentalMobileConfirmationMode = ConfirmationMode(rawValue: rentalMobileConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer RENTAL MOBILE CONF. Contacte a Soporte TC")
                return
            }
            
            
            guard let rentalIdConfirmationMode = ConfirmationMode(rawValue: rentalIdConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer RENTAL ID CONF. Contacte a Soporte TC")
                return
            }
            
            guard let dateMobileConfirmationMode = ConfirmationMode(rawValue: dateMobileConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer DATE MOBILE CONF. Contacte a Soporte TC")
                return
            }
            
            guard let dateIdConfirmationMode = ConfirmationMode(rawValue: dateIdConfirmationMode) else {
                showError(.campoInvalido, "Error al establecer DATE ID CONF. Contacte a Soporte TC")
                return
            }
            
            guard let createPersonalAccountMode = CreateAccountMode(rawValue: createPersonalAccountMode) else {
                showError(.campoInvalido, "Error al establecer modo de cracion de cuentas personales. Contacte a Soporte TC")
                return
            }
            
            guard let createBuisnessAccountMode = CreateAccountMode(rawValue: createBuisnessAccountMode) else {
                showError(.campoInvalido, "Error al establecer modo de cracion de cuentas empresariales. Contacte a Soporte TC")
                return
            }
            
            guard let currency = Currencies(rawValue: currency) else {
                showError(.campoInvalido, "Error al establecer CURRENCY. Contacte a Soporte TC")
                return
            }
            
            guard let restrictOrderCreation = Int(restrictOrderCreation) else {
                
                showError(.campoInvalido, "Error al establecer RESTRICT ORDER CREATE. Contacte a Soporte TC")
                return
            }
            
            guard let restrictOrderClosing = Int(restrictOrderClosing)?.value else {
                showError(.campoInvalido, "Error al establecer RESTRICT ORDER CLOSE. Contacte a Soporte TC")
                return
            }
            
            guard let restrictOrderCharges = Int(restrictOrderCharges)?.value else {
                showError(.campoInvalido, "Error al establecer RESTRICT ORDER CHARGE. Contacte a Soporte TC")
                return
            }
            
            guard let restrictSaleCharges = Int(restrictSaleCharges)?.value else {
                showError(.campoInvalido, "Error al establecer RESTRICT SALE CHARGES. Contacte a Soporte TC")
                return
            }
            
            guard let restrictMermProduct = Int(restrictMermProduct)?.value else {
                showError(.campoInvalido, "Error al establecer RESTRICT MERM PRODUCT. Contacte a Soporte TC")
                return
            }
            
            guard let restrictDeleteCharges = Int(restrictDeleteCharges)?.value else {
                showError(.campoInvalido, "Error al establecer RESTRICT DEL CHARGE. Contacte a Soporte TC")
                return
            }
            
            guard let restrictDeletePayments = Int(restrictDeletePayments)?.value else {
                showError(.campoInvalido, "Error al establecer RESTRICT DEL PAY. Contacte a Soporte TC")
                return
            }
            
            guard let restrictDeleteFiscal = Int(restrictDeleteFiscal)?.value else {
                showError(.campoInvalido, "Error al establecer RESTRICT DEL FISCAL. Contacte a Soporte TC")
                return
            }
            
            guard let autoDeleteCTAM = Int(autoDeleteCTAM)?.value else {
                showError(.campoInvalido, "Error al establecer AUTO DEL CTAM. Contacte a Soporte TC")
                return
            }
            
            guard let openFiscalInvoce = Int(openFiscalInvoce)?.value else {
                showError(.campoInvalido, "Error al establecer FISCAL MANUAL PAY. Contacte a Soporte TC")
                return
            }
            
            guard let saleSerialization = SerializationSequenceType(rawValue: saleSerialization) else {
                showError(.campoInvalido, "Error al establecer SERIALIZACION DE VENTAS. Contacte a Soporte TC")
                return
            }

            guard let orderSerialization = SerializationSequenceType(rawValue: orderSerialization) else {
                showError(.campoInvalido, "Error al establecer SERIALIZACION DE ORDENES. Contacte a Soporte TC")
                return
            }
            
            guard let fiscalSerialization = SerializationSequenceType(rawValue: fiscalSerialization) else {
                showError(.campoInvalido, "Error al establecer SERIALIZACION DE FACTURAS. Contacte a Soporte TC")
                return
            }
            
            var _servicePriceRange: [ConfigStoreProcessingPriceRange] = []
            /// [PriceRangeItem]
            self.servicePriceRange.forEach { item in
                
                guard let lowerRange = Double(item.lowerRange)?.toCents else {
                    return
                }
                
                guard let upperRange = Double(item.upperRange)?.toCents else {
                    return
                }
                
                guard let pricea = Double(item.pricea)?.toCents else {
                    return
                }
                
                guard let priceb = Double(item.priceb)?.toCents else {
                    return
                }
                
                guard let pricec = Double(item.pricec)?.toCents else {
                    return
                }
                
                _servicePriceRange.append(.init(
                    id: item.id,
                    rangeNumber: item.rangeNumber,
                    lowerRange: lowerRange,
                    upperRange: upperRange,
                    pricea: pricea,
                    priceb: priceb,
                    pricec: pricec
                ))
                
            }
            
            
            var _productPriceRange: [ConfigStoreProcessingPriceRange] = []
            /// [PriceRangeItem]
            self.productPriceRange.forEach { item in
                
                guard let lowerRange = Double(item.lowerRange.replace(from: ",", to: ""))?.toCents else {
                    return
                }
                
                guard let upperRange = Double(item.upperRange.replace(from: ",", to: ""))?.toCents else {
                    return
                }
                
                guard let pricea = Double(item.pricea.replace(from: ",", to: ""))?.toCents else {
                    return
                }
                
                guard let priceb = Double(item.priceb.replace(from: ",", to: ""))?.toCents else {
                    return
                }
                
                guard let pricec = Double(item.pricec.replace(from: ",", to: ""))?.toCents else {
                    return
                }
                
                _productPriceRange.append(.init(
                    id: item.id,
                    rangeNumber: item.rangeNumber,
                    lowerRange: lowerRange,
                    upperRange: upperRange,
                    pricea: pricea,
                    priceb: priceb,
                    pricec: pricec
                ))
                
            }
            
            if generalComision.isEmpty {
                generalComision = "0"
            }
            
            guard let generalComision = Double(generalComision)?.toCents else {
                showError(.campoInvalido, "Error al establecer GENERALCOMISION. Contacte a Soporte TC")
                return
            }
            
            
            var orderPendingPickupLimitStart = Int(orderPendingPickupLimitStart) ?? 7
            
            var orderPendingPickupLimitEnd = Int( orderPendingPickupLimitEnd) ?? 7
            
            var orderPendingPickupLimitEveryWhen = Int( orderPendingPickupLimitEveryWhen) ?? 30
            
            if orderPendingPickupLimitAlert {
                
                guard let _orderPendingPickupLimitStart = Int(self.orderPendingPickupLimitStart) else {
                    showError(.campoInvalido, "Establesca dias en lo que iniciara recordatorios eq pend de entrega")
                    return
                }
                
                guard let _orderPendingPickupLimitEnd = Int(self.orderPendingPickupLimitEnd) else {
                    showError(.campoInvalido, "Establesca dias de intervalos de recordatorios eq pend de entrega")
                    return
                }
                
                guard let _orderPendingPickupLimitEveryWhen = Int(self.orderPendingPickupLimitEveryWhen) else {
                    showError(.campoInvalido, "Establesca dias en lo que iniciara recordatorios eq pend de entrega")
                    return
                }
                
                orderPendingPickupLimitStart = _orderPendingPickupLimitStart
                
                orderPendingPickupLimitEnd = _orderPendingPickupLimitEnd
                
                orderPendingPickupLimitEveryWhen = _orderPendingPickupLimitEveryWhen
                
            }
            
            guard let orderAddedProductDelivery = ProductDeliveryType(rawValue: orderAddedProductDelivery) else {
                showError(.campoInvalido, "Error al establecer PROD DELIVERY TYPE. Contacte a Soporte TC")
                return
            }
            
            guard let saleProductDelivery = ProductDeliveryType(rawValue: saleProductDelivery) else {
                showError(.campoInvalido, "Error al establecer PROD DELIVERY TYPE. Contacte a Soporte TC")
                return
            }
            
            guard let creditType = StoreCreditType(rawValue: creditType) else {
                showError(.campoInvalido, "Error al establecer CREDIT TYPE. Contacte a Soporte TC")
                return
            }
            
            guard let billingDate = Int(billingDate) else {
                showError(.campoInvalido, "Establesca día de facturación")
                billingDateField.select()
                return
            }
            
            guard let creditDays = Int( creditDays) else {
                showError(.campoInvalido, "Establesca Fecha de Facturación")
                creditDaysField.select()
                return
            }
            
            guard let initialCreditLimit = Double(initialCreditLimit)?.toCents else {
                showError(.campoInvalido, "Establesca limite de credito")
                initialCreditLimitField.select()
                return
            }
            
            var rewardsPrograme: ConfigRewardsPrograme? = nil
            
            if let rewardsStructureTypeHelper {
                
                guard let tierClubBreak = Double( rewardsTierClubBreak)?.toCents else {
                    showError(.campoInvalido, "Ingrese Puntos para pertenecer al nivel CLUB")
                    rewardsTierClubBreakField.select()
                    return
                }
                
                guard let tierBronceBreak = Double( rewardsTierBronceBreak)?.toCents else {
                    showError(.campoInvalido, "Ingrese Puntos para pertenecer al nivel BRONCE")
                    rewardsTierBronceBreakField.select()
                    return
                }
                
                guard let tierSilverBreak = Double( rewardsTierSilverBreak)?.toCents else {
                    showError(.campoInvalido, "Ingrese Puntos para pertenecer al nivel PLATA")
                    rewardsTierSilverBreakField.select()
                    return
                }
                
                guard let tierGoldBreak = Double( rewardsTierGoldBreak)?.toCents else {
                    showError(.campoInvalido, "Ingrese Puntos para pertenecer al nivel ORO")
                    rewardsTierGoldBreakField.select()
                    return
                }
                
                guard let tierDiamondBreak = Double( rewardsTierDiamondBreak)?.toCents else {
                    showError(.campoInvalido, "Ingrese Puntos para pertenecer al nivel DIAMANTE")
                    rewardsTierDiamondBreakField.select()
                    return
                }
                
                
                
                guard let percentProductTierClub = Double(rewardsPercentProductTierClub) else {
                    showError(.campoInvalido, "Imgrese porcentaje de recompensa en productos al nivel CLUB")
                    rewardsPercentProductTierClubField.select()
                    return
                }
                
                guard let percentProductTierBronce = Double(rewardsPercentProductTierBronce) else {
                    showError(.campoInvalido, "Imgrese porcentaje de recompensa en productos al nivel BRONCE")
                    rewardsPercentProductTierBronceField.select()
                    return
                }
                
                guard let percentProductTierSilver = Double(rewardsPercentProductTierSilver) else {
                    showError(.campoInvalido, "Imgrese porcentaje de recompensa en productos al nivel PLATA")
                    rewardsPercentProductTierSilverField.select()
                    return
                }
                
                guard let percentProductTierGold = Double(rewardsPercentProductTierGold) else {
                    showError(.campoInvalido, "Imgrese porcentaje de recompensa en productos al nivel ORO")
                    rewardsPercentProductTierGoldField.select()
                    return
                }
                
                guard let percentProductTierDiamond = Double(rewardsPercentProductTierDiamond) else {
                    showError(.campoInvalido, "Imgrese porcentaje de recompensa en productos al nivel DIAMANTE")
                    rewardsPercentProductTierDiamondField.select()
                    return
                }
                
                
                
                guard let percentServiceTierClub = Double( rewardsPercentServiceTierClub) else {
                    showError(.campoInvalido, "Ingrese porcentaje de recompensa en servicio al nivel CLUB")
                    rewardsPercentServiceTierClubField.select()
                    return
                }
                
                guard let percentServiceTierBronce = Double( rewardsPercentServiceTierBronce) else {
                    showError(.campoInvalido, "Ingrese porcentaje de recompensa en servicio al nivel BRONCE")
                    rewardsPercentServiceTierBronceField.select()
                    return
                }
                
                guard let percentServiceTierSilver = Double( rewardsPercentServiceTierSilver) else {
                    showError(.campoInvalido, "Ingrese porcentaje de recompensa en servicio al nivel PLATA")
                    rewardsPercentServiceTierSilverField.select()
                    return
                }
                
                guard let percentServiceTierGold = Double( rewardsPercentServiceTierGold) else {
                    showError(.campoInvalido, "Ingrese porcentaje de recompensa en servicio al nivel ORO")
                    rewardsPercentServiceTierGoldField.select()
                    return
                }
                
                guard let percentServiceTierDiamond = Double( rewardsPercentServiceTierDiamond) else {
                    showError(.campoInvalido, "Ingrese porcentaje de recompensa en servicio al nivel DIAMANTE")
                    rewardsPercentServiceTierDiamondField.select()
                    return
                }
                
                
                
                guard let refrenceTierOne = Double(rewardsRefrenceTierOne)?.toCents else {
                    showError(.campoInvalido, "Ingrese recompensa por referido nivel 1")
                    rewardsRefrenceTierOneField.select()
                    return
                }
                
                guard let refrenceTierTwo = Double(rewardsRefrenceTierTwo)?.toCents else {
                    showError(.campoInvalido, "Ingrese recompensa por referido nivel 2")
                    rewardsRefrenceTierTwoField.select()
                    return
                }
                
                guard let refrenceTierThree = Double(rewardsRefrenceTierThree)?.toCents else {
                    showError(.campoInvalido, "Ingrese recompensa por referido nivel 3")
                    rewardsRefrenceTierThreeField.select()
                    return
                }
                
                rewardsPrograme = .init(
                    structureType: rewardsStructureTypeHelper,
                    tierClubBreak: tierClubBreak,
                    tierBronceBreak: tierBronceBreak,
                    tierSilverBreak: tierSilverBreak,
                    tierGoldBreak: tierGoldBreak,
                    tierDiamondBreak: tierDiamondBreak,
                    percentProductTierClub: percentProductTierClub,
                    percentProductTierBronce: percentProductTierBronce,
                    percentProductTierSilver: percentProductTierSilver,
                    percentProductTierGold: percentProductTierGold,
                    percentProductTierDiamond: percentProductTierDiamond,
                    percentServiceTierClub: percentServiceTierClub,
                    percentServiceTierBronce: percentServiceTierBronce,
                    percentServiceTierSilver: percentServiceTierSilver,
                    percentServiceTierGold: percentServiceTierGold,
                    percentServiceTierDiamond: percentServiceTierDiamond,
                    refrenceTierOne: refrenceTierOne,
                    refrenceTierTwo: refrenceTierTwo,
                    refrenceTierThree: refrenceTierThree,
                    welcomeGift: welcomeGift,
                    tierClubItems: rewardsTierClubItems,
                    tierBronceItems: rewardsTierBronceItems,
                    tierSilverItems: rewardsTierSilverItems,
                    tierGoldItems: rewardsTierGoldItems,
                    tierDiamondItems: rewardsTierDiamondItems
                )
                
                
            }
            
            /// `ConfigContactTags`
            
            guard let instituteTag = ConfigConfigContactTagsInstitudType(rawValue: instituteTag) else {
                showError(.campoInvalido, "Error al establecer INTITUD TAG. Contacte a Soporte TC")
                return
            }
            
            guard let customerType = ConfigConfigContactTagsCustomerType(rawValue: customerType) else {
                showError(.campoInvalido, "Error al establecer CUSTOMER TAG. Contacte a Soporte TC")
                return
            }
            
            guard let operationalContact = UUID(uuidString: operationalContact) else {
                showError(.campoInvalido, "Error al establecer OP CONTACT. Contacte a Soporte TC")
                return
            }
            
            guard let salesContact = UUID(uuidString: salesContact) else {
                showError(.campoInvalido, "Error al establecer SALE CONTACT. Contacte a Soporte TC")
                return
            }
            
            guard let finacialContact = UUID(uuidString: finacialContact) else {
                showError(.campoInvalido, "Error al establecer FINANCIAL CONTACT. Contacte a Soporte TC")
                return
            }
            
            let configStoreProcessing = ConfigStoreProcessing(
                moduleProfile: _moduleProfile,
                gridView: gridView,
                accountMobileConfirmationMode: accountMobileConfirmationMode,
                accountIdConfirmationMode: accountIdConfirmationMode,
                orderMobileConfirmationMode: orderMobileConfirmationMode,
                rentalMobileConfirmationMode: rentalMobileConfirmationMode,
                dateMobileConfirmationMode: dateMobileConfirmationMode,
                orderIdConfirmationMode: orderIdConfirmationMode,
                rentalIdConfirmationMode: rentalIdConfirmationMode,
                dateIdConfirmationMode: dateIdConfirmationMode,
                createPersonalAccountMode: createPersonalAccountMode,
                createBuisnessAccountMode: createBuisnessAccountMode,
                currency: currency,
                restrictOrderCreation: restrictOrderCreation,
                restrictOrderClosing: restrictOrderClosing,
                restrictOrderCharges: restrictOrderCharges,
                restrictSaleCharges: restrictSaleCharges,
                restrictMermProduct: restrictMermProduct,
                restrictDeleteCharges: restrictDeleteCharges,
                restrictDeletePayments: restrictDeletePayments,
                restrictDeleteFiscal: restrictDeleteFiscal,
                autoDeleteCTAM: autoDeleteCTAM,
                openFiscalInvoce: openFiscalInvoce,
                generalComision: generalComision,
                generalPremier: 0,
                // viewPricesOnWeb: viewPricesOnWeb,
                // varialPricesDisclosure: varialPricesDisclosure,
                servicePriceRange: _servicePriceRange,
                productPriceRange: _productPriceRange,
                orderDateReminderMorning: orderDateReminderMorning,
                orderDateReminderConcurring: orderDateReminderConcurring,
                orderDateReminderAssistedOperator: orderDateReminderAssistedOperator,
                orderPendingPickupLimitAlert: orderPendingPickupLimitAlert,
                orderPendingPickupLimitStart: orderPendingPickupLimitStart,
                orderPendingPickupLimitEnd: orderPendingPickupLimitEnd,
                orderPendingPickupLimitEveryWhen: orderPendingPickupLimitEveryWhen,
                orderPendingPickupLimitEveryWhenMsg: orderPendingPickupLimitEveryWhenMsg,
                orderPendingPickupLimitThreeDayAlertMsg: orderPendingPickupLimitThreeDayAlertMsg,
                orderPendingPickupLimitOneDayAlertMsg: orderPendingPickupLimitOneDayAlertMsg,
                orderPendingPickupLimitZeroDayAlertMsg: orderPendingPickupLimitZeroDayAlertMsg,
                orderContract: orderContract,
                orderAddedProductDelivery: orderAddedProductDelivery,
                saleProductDelivery: saleProductDelivery,
                creditType: creditType,
                billingDate: billingDate,
                creditDays: creditDays,
                initialCreditLimit: initialCreditLimit,
                creditRequisitObject: creditRequisitObject,
                rewardsPrograme: rewardsPrograme,
                orderSerialization: orderSerialization,
                fiscalSerialization: fiscalSerialization,
                saleSerialization: saleSerialization
            )
            
            let configContactTags = ConfigContactTags(
                requireInstituteTag: requireInstituteTag,
                instituteTag: instituteTag,
                customerType: customerType,
                requierServiceAddress: requierServiceAddress,
                requierMailingAddrees: requierMailingAddrees,
                requirePhysicalAddress: requirePhysicalAddress,
                operationalContact: operationalContact,
                salesContact: salesContact,
                finacialContact: finacialContact,
                sendNewBusinessAccountComunication: sendNewBusinessAccountComunication
            )
            
            loadingView(show: true)
            
            API.custAPIV1.saveConfigs(
                configStoreProcessing: configStoreProcessing,
                configContactTags: configContactTags,
                configServiceTags: nil,
                configGeneral: nil
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                showSuccess(.operacionExitosa, "Actualizado")
                
            }
        
        }
    }
}
