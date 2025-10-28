import Web
import Foundation
import TCFundamentals
import TCFireSignal
import JavaScriptKit
import WebSocketAPI

@available(*, deprecated, message: "This must be replace with poccess configurable option.")
var sneekPeekLimit = 4

let localTestIp = "192.168.0.111"

public struct SkylineWeb {
	
	public private(set) var mode = "beta"
    
	public private(set) var version = 0
	
	public private(set) var revision = 15
    
    public private(set) var fix = 13
	
	public init() {}
    
}

var developmentMode: ApplicationAPIMode = .produccion

public var accountBalance: API.custAPIV1.AccountBalanceResponse? = nil

public var webSocket: WebSocket? = nil

public var panelMode: PanelMode = .serviceOrder

/// This varibles controls if the default landing page after Skyline.Login
/// `Dont forget to add page to templeat routes`
public var skylineLandingPage = ""

/// Device uniq token, just to differ one connection from an other
public var custCatchChatConnID: String = ""

/// The DINAMIC TOKEN recived from API.authV1.getChatToken
public var custCatchChatToken: String = ""

/// The UNIQUE TOKEN recived from login
public var custCatchMyChatToken: String = ""

public var thisAppID: String = ""

public var thisAppToken: String = ""

public var custCatchUrl: String = ""

public var custCatchUser: String = ""

public var custCatchHerk: Int = 0

public var custCatchStore: UUID = .init()

public var custCatchGroop: UUID = .init()

public var custCatchToken: String = ""

public var custCatchMid: String = ""

public var custCatchKey: String = ""

public var custCatchID: UUID = .init()

public var linkedProfile: [PanelConfigurationObjects] = []

public var tcaccount: TCAccountsItem? = nil
 
/// This contols main menu (left) aditional items
public var aditionalMenuItems: [AditionalSideMenuItems] = []

/// This contols side menu (right) aditional items
public var aditionalSideMenuItems: [AditionalSideMenuItems] = []

public var banks: [BanksItem] = []

public var mybanks: [CustBankUserProfile] = []

public var searchChargeCatch: [String:[SearchChargeResponse]] = [:]

public var paymentMeths: [PaymentMethsRow] = []

public var custWebFilesLogos: CustWebFilesLogos? = nil

public var configStoreProduct: ConfigStoreProduct = .init()

public var configContactTags: ConfigContactTags = .init()

public var configServiceTags: ConfigServiceTags = .init()

public var configStoreProcessing: ConfigStoreProcessing = .init()

public var configGeneral: ConfigGeneral = .init()

public var customerServiceProfile: CustomerServiceProfile? = nil

public var alertManagerConfiguration: AlertManagerConfiguration = .init(
    frequency: .byHourly,
    level: .low,
    executedAt: 0
)

/// order, rent, sale, admin work force
public var custOperationWorkProfile: CustOperationWorkProfile = .init()

public var configStore: ConfigStore = .init()

public var fiscalProfile: FiscalEndpointV1.GetProfileResponse? = nil

public var fiscalProfiles: [FiscalEndpointV1.Profile] = []

public var stores: [UUID:CustStore] = [:]

public var bodegas: [UUID:CustStoreBodegasSinc] = [:]

public var seccions: [UUID:CustStoreSeccionesSinc] = [:]

public var socialAccountCathtByUUID: [UUID:CustSocialAccounts] = [:]

public var socialAccountCathtByToken: [String:CustSocialAccounts] = [:]

public var hasGlobalyLoadedUsers: Bool = false

/// CustUsername catch by row uuid
public var userCathByUUID: [UUID:CustUsername] = [:]

/// CustUsername catch by user token
public var userCathByToken: [String:CustUsername] = [:]

public var rentalProducts: [CustStoreDepsRental] = []

public var brands: [CustBrands] = []

/// Order Detail Catch
public var acctMinCatch: [UUID:CustAcctMin] = [:]

public var orderCatch: [UUID:CustOrderLoadFolioDetails] = [:]

public var notesCatch: [UUID:[CustOrderLoadFolioNotes]] = [:]

public var paymentsCatch: [UUID:[CustOrderLoadFolioPayments]] = [:]

public var chargesCatch: [UUID:[CustOrderLoadFolioCharges]] = [:]

public var pocsCatch: [UUID:[CustPOCInventoryOrderView]] = [:]

public var filesCatch: [UUID:[CustOrderLoadFolioFiles]] = [:]

public var equipmentsCatch: [UUID:[CustOrderLoadFolioEquipments]] = [:]

public var rentalsCatch: [UUID:[CustPOCRentalsMin]] = [:]

public var orderHighPriorityNoteCatch: [UUID:[HighPriorityNote]] = [:]

public var tasksCatch: [UUID:[CustTaskAuthorizationManagerQuick]] = [:]

public var accountHighPriorityNoteCatch: [UUID:[HighPriorityNote]] = [:]

public var custOrderRouteCatch: [UUID:CustOrderRoute] = [:]

public var storeDeps: [CustStoreDepsAPI] = []

public var waterMarkItems: [CustWebFiles] = []

public var socialProfiles: [CustSocialProfileQuick] = []

public var socialPages: [CustSocialPageQuick] = []

/// This is optional
public var transferOrderCatch: [UUID:CustTranferManager] = [:]

public var workMap: [
    Int: [
        Int: [
            Int: CustOperationWorkProfile
        ]
    ]
] = [:]

public var generalWorkload: CustOperationWorkProfile = .init(order: 0, rent: 0, sale: 0, admin: 0)

/// Order ID / Account ID
public var minViewOrderAccountRefrence: [UUID:UUID] = [:]
/// Account ID / AccoutOverview
public var minViewAcctRefrence: [UUID:AccoutOverview] = [:]
/// Account ID / Min Dv
public var minViewDivRefrence: [UUID:Div] = [:]

var fiscCodeRefrence: [String: String] = [:]
var fiscUnitRefrence: [String: String] = [:]

var productUsedFiscCodesIsLoaded = false
var productUsedFiscCode: [APISearchResultsGeneral] = []
var productUsedFiscUnit: [APISearchResultsGeneral] = []

var serviceUsedFiscCodesIsLoaded = false
var serviceUsedFiscCode: [APISearchResultsGeneral] = []
var serviceUsedFiscUnit: [APISearchResultsGeneral] = []

var manualUsedFiscCodesIsLoaded = false
var manualUsedFiscCode: [APISearchResultsGeneral] = []
var manualUsedFiscUnit: [APISearchResultsGeneral] = []

var rentalUsedFiscCodesIsLoaded = false
var rentalUsedFiscCode: [APISearchResultsGeneral] = []
var rentalUsedFiscUnit: [APISearchResultsGeneral] = []

/// Create Order Manager Catch
/// `Type of object` EG:  Refirgerador  iPhone, Computadora
var orderManagerType: [CustOrderManagerType] = []
/// `Brands` related to `Type of object`
var orderManagerBrand: [CustOrderManagerBrand] = []
/// `Models` related to `Brands` related to `Type of object`
var orderManagerModel: [CustOrderManagerModel] = []

var ignoredKeys: [String] = ["ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown", "Escape", "Meta", "Shift", "Control", "Alt", "CapsLock",  ".", "Tab", "Backspace", "Delete"]

var ignoredKeysOnlyNumbers: [String] = ["ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown", "Escape", "Meta", "Shift", "Control", "Alt", "CapsLock", "Tab", "Backspace", "Delete"]

var ignoredKeysOnlyTime: [String] = ["ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown", "Escape", "Meta", "Shift", "Control", "Alt", "CapsLock",  ":", "Tab", "Backspace", "Delete"]

/// If any user can cross login  this platform
public var allowedDomain: [String] = []

/// CATCH control for product: productType
public var productTypeRefrence: [String] = []

/// CATCH control for product: productSubType
public var productSubTypeRefrence: [String:[String]] = [:]

let hCaptchaSiteKey = "e1e6c3cd-cade-41e4-92f4-8caf3e9c1cda"


private var _skyline: _SkyLine = .init()

class _SkyLine {
    
	static var shared: _SkyLine { _skyline }
	
    /// .init(.rgba(0, 0, 0, 0.7))
	lazy var loadingView = Div{
			Table {
				Tr {
					Td {
                    
                    Img()
                        .src("/skyline/media/cross.png")
                        .position(.absolute)
                        .cursor(.pointer)
                        .width(18.px)
                        .right(25.px)
                        .top(25.px)
                        .onClick({ _, event in
                            faseOutLoadingView()
                        })

						Img()
							.src("/skyline/media/tierraceroRoundLogoWhite.svg")
							.marginBottom(12.px)
							.width(100.px)
					}
					.align(.center)
					.verticalAlign(.middle)
				}
			}
			.width(100.percent)
			.height(100.percent)
		}
    .backgroundColor(.transparentBlack)
    .filter(.opacity(0))
    .position(.absolute)
    .height(100.percent)
    .width(100.percent)
    .id("loadingView")
    .zIndex(999999998)
    .display(.none)
    .left(0.px)
    .top(0.px)
    
    lazy var minimizedGrid = Div()
        .position(.absolute)
        .bottom(12)
        .left(24)
        .id("minimizedGrid")
    
	lazy var messageGrid = Div()
		.position(.absolute)
        .zIndex(999999999)
		.bottom(24)
		.right(24)
		.id("messageGrid")
    
    @State var wsevent = ""
	
}
extension WebApp {
    
    public var loadingView: Div { _SkyLine.shared.loadingView }
    
    public var messageGrid: Div { _SkyLine.shared.messageGrid }
    
    public var minimizedGrid: Div { _SkyLine.shared.minimizedGrid }
    
    public var wsevent: State<String> {_SkyLine.shared.$wsevent}
}

//class SkylineApp: WebApp{
//	@State var keyup = ""
//
//}

