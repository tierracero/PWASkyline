import Foundation
import TCFundamentals
#if canImport(CodyFire)
import CodyFire
#endif

extension CustAssetsComponents {


    /// store, warehose, account, subAccount
    public enum InitiateAssetItemViewType: Payloadable {

        case store(CustStore)

        case warehose(CustStore)

        case account(account: CustAcct, store: CustStore)

        case subAccount(subAccount: CustSubAcct, store: CustStore)

        public var description: String {
            switch self {
            case .store:
            return "Tienda"
            case .warehose:
            return "Bodega"
            case .account:
            return "Cuenta"
            case .subAccount:
            return "Sub Cliente"
            }
        }

        public var relationName: String {

            switch self {
            case .store(let item):
            return item.name
            case .warehose(let item):
            return item.name
            case .account(let item, let store):
                if item.type == .personal {
                    return "\(item.folio) \(item.firstName) \(item.lastName)"
                }
                else {
                    return "\(item.folio) \(item.businessName) \(item.fiscalRfc) \(item.fiscalRazon)"
                }
            case .subAccount(let item, let store):
            if item.type == .personal {
                    return "\(item.folio) \(item.firstName) \(item.lastName)"
                }
                else {
                    return "\(item.folio) \(item.businessName)"
                }
            }
        }

        public var relationId: UUID {

            switch self {
            case .store(let item):
            return item.id
            case .warehose(let item):
            return item.id
            case .account(let item, _):
            return item.id
            case .subAccount(let item, _):
            return item.custAcct
            }

        }

        public var relationType: CustCommercialAssetsLocationLinkedType {
            switch self {
            case .store:
            return .store
            case .warehose:
            return .warehose
            case .account, .subAccount:
            return .customer
            }
        }

        /// Coordinates of the physical store or warehouse where the item is placed.
        /// Account and sub-account ownership does not change the item's physical parent.
        public var latitude: Double? {
            switch self {
            case .store(let store), .warehose(let store):
                return store.lat.flatMap { Double($0) }
            case .account(_, let store), .subAccount(_, let store):
                return store.lat.flatMap { Double($0) }
            }
        }

        /// Coordinates of the physical store or warehouse where the item is placed.
        /// Account and sub-account ownership does not change the item's physical parent.
        public var longitude: Double? {
            switch self {
            case .store(let store), .warehose(let store):
                return store.lon.flatMap { Double($0) }
            case .account(_, let store), .subAccount(_, let store):
                return store.lon.flatMap { Double($0) }
            }
        }

    }

    public struct CreateAssetItemFile: Payloadable {
        
        public let fileName: String
        
        public let isAvatar: Bool
        
        public init(
            fileName: String,
            isAvatar: Bool
        ) {
            self.fileName = fileName
            self.isAvatar = isAvatar
        }
        
    }
    
    public struct CreateAssetItemObject: Payloadable {
                
        /// Optional section classification within the asset category hierarchy. [CustCommercialAssetsSection] Section
        public let section: UUID?

        /// Optional subsection classification below the asset section. [CustCommercialAssetsSubSection]
        public let subSection: UUID?
        
        public let acquisitionAt: Int64
        
        public let acquisitionCost: Int64
        
        public let currentCost: Int64
        
        public let serial: String?
        
        public let name: String
        
        public let serviceCard: String?
        
        public let images: [CreateAssetItemFile]
        
        public init(
            section: UUID?,
            subSection: UUID?,
            acquisitionAt: Int64,
            acquisitionCost: Int64,
            currentCost: Int64,
            serial: String?,
            name: String,
            serviceCard: String?,
            images: [CreateAssetItemFile]
        ) {
            self.section = section
            self.subSection = subSection
            self.acquisitionAt = acquisitionAt
            self.acquisitionCost = acquisitionCost
            self.currentCost = currentCost
            self.serial = serial
            self.name = name
            self.serviceCard = serviceCard
            self.images = images
        }

    }
    
    public struct CreateAssetItemRequest: CrossPlatformPayload {
        
        /// store, warehose, account, subAccount
        public let type: InitiateAssetItemViewType
        
        public let purchasFiscalDocumentFolio: String

        public let purchasFiscalDocumentId: UUID?
        
        public let commercialAssetId: UUID
        
        public let department: UUID?
        
        public let categorie: UUID?
        
        public let subcategorie: UUID?
        
        public let items: [CreateAssetItemObject]
        
        public init(
            type: InitiateAssetItemViewType,
            purchasFiscalDocumentFolio: String,
            purchasFiscalDocumentId: UUID?,
            commercialAssetId: UUID,
            department: UUID?,
            categorie: UUID?,
            subcategorie: UUID?,
            items: [CreateAssetItemObject]
        ) {
            self.type = type
            self.purchasFiscalDocumentFolio = purchasFiscalDocumentFolio
            self.purchasFiscalDocumentId = purchasFiscalDocumentId
            self.commercialAssetId = commercialAssetId
            self.department = department
            self.categorie = categorie
            self.subcategorie = subcategorie
            self.items = items
        }
        
    }

    public struct CreateAssetItemResponse: Payloadable {
        
        public let items: [CustCommercialAssetsItem]
        
        public init(
            items: [CustCommercialAssetsItem]
        ) {
            self.items = items
        }
    }

#if canImport(CodyFire)
    public static func createAssettem(
        type: InitiateAssetItemViewType,
        purchasFiscalDocumentFolio: String,
        purchasFiscalDocumentId: UUID?,
        commercialAssetId: UUID,
        department: UUID?,
        categorie: UUID?,
        subcategorie: UUID?,
        items: [CreateAssetItemObject]
    ) -> APIRequest<APIResponseGeneric<CreateAssetItemResponse>> {
        request("createAssettem", payload: CreateAssetItemRequest(
            type: type,
            purchasFiscalDocumentFolio: purchasFiscalDocumentFolio,
            purchasFiscalDocumentId: purchasFiscalDocumentId,
            commercialAssetId: commercialAssetId,
            department: department,
            categorie: categorie,
            subcategorie: subcategorie,
            items: items
        )).method(.post)
    }
#endif
}
