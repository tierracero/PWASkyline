//
//  CustCommercialTrips+GetTrip.swift
//  TCFireSignal
//
//  Created by Victor Cantu on 7/4/26.
//

import Foundation
import TCFundamentals
#if canImport(CodyFire)
import CodyFire
#endif

extension CustCommercialTripsComponents {
    

    public struct GetTripItem: Payloadable {
        
        public var id: UUID
        
        public var createdAt: Int64
        
        public var modifiedAt: Int64
        
        public var name: String
        
        public var folio: String
        
        public var operadorId: CustCommercialTripOperador
        
        public var vehicalId: CustCommercialTripVehical
        
        public var permitId: CustCommercialTripPermit
        
        public var hasDangerousMaterial: Bool
        
        public var insuranceCivilId: CustCommercialTripInsurance?
        
        public var insuranceAmbientId: CustCommercialTripInsurance?
        
        public var insurancePayloadId: CustCommercialTripInsurance?
        
        public var trailers: [CustCommercialTripTrailer]
        
        public var locations: [FiscalLocationItem]
        
        public var merchandise: [FiscalMercanciaItem]

        /// Initial vehicle odometer reading in whole kilometers.
        public var odometerInitial: Int64?

        /// Final vehicle odometer reading in whole kilometers.
        public var odometerFinal: Int64?
        
        public var cost: Int64
        
        public var balance: Int64
        
        public var fiscalId: UUID?
        
        /// pending, inProgress, completed, cancelled
        public var status: FiscalTripFollowupStatus
        
        public init(
            id: UUID,
            createdAt: Int64,
            modifiedAt: Int64,
            name: String,
            folio: String,
            operadorId: CustCommercialTripOperador,
            vehicalId: CustCommercialTripVehical,
            permitId: CustCommercialTripPermit,
            hasDangerousMaterial: Bool,
            insuranceCivilId: CustCommercialTripInsurance?,
            insuranceAmbientId: CustCommercialTripInsurance?,
            insurancePayloadId: CustCommercialTripInsurance?,
            trailers: [CustCommercialTripTrailer],
            locations: [FiscalLocationItem],
            merchandise: [FiscalMercanciaItem],
            odometerInitial: Int64? = nil,
            odometerFinal: Int64? = nil,
            cost: Int64,
            balance: Int64,
            fiscalId: UUID?,
            status: FiscalTripFollowupStatus
        ) {
            self.id = id
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.name = name
            self.folio = folio
            self.operadorId = operadorId
            self.vehicalId = vehicalId
            self.permitId = permitId
            self.hasDangerousMaterial = hasDangerousMaterial
            self.insuranceCivilId = insuranceCivilId
            self.insuranceAmbientId = insuranceAmbientId
            self.insurancePayloadId = insurancePayloadId
            self.trailers = trailers
            self.locations = locations
            self.merchandise = merchandise
            self.odometerInitial = odometerInitial
            self.odometerFinal = odometerFinal
            self.cost = cost
            self.balance = balance
            self.fiscalId = fiscalId
            self.status = status
        }
        
    }
    
    public struct GetTripRequest: CrossPlatformPayload {
        public let tripId: HybridIdentifier
        
        public init(
            tripId: HybridIdentifier
        ) {
            self.tripId = tripId
        }
    }
    
    public struct GetTripResponse: Payloadable {
        
        public var trip: GetTripItem
        
        public var account: CustAcctQuick
        
        public var notes: [CustGeneralNotesQuick]
        
        public var payments: [CustOrderLoadFolioPayments]
        
        public var charges: [CustOrderLoadFolioCharges]
        
        public var costs: [CustGastosEgresos]

        public var contracts: [CustPageContent]
        
        public var pocs: [CustPOCInventoryOrderView]
        
        public var orderHighPriorityNote: [HighPriorityNote]
        
        public var accountHighPriorityNote: [HighPriorityNote]
        
        public init(
            trip: GetTripItem,
            account: CustAcctQuick,
            notes: [CustGeneralNotesQuick],
            payments: [CustOrderLoadFolioPayments],
            charges: [CustOrderLoadFolioCharges],
            costs: [CustGastosEgresos],
            contracts: [CustPageContent],
            pocs: [CustPOCInventoryOrderView],
            orderHighPriorityNote: [HighPriorityNote],
            accountHighPriorityNote: [HighPriorityNote]
        ) {
            self.trip = trip
            self.account = account
            self.notes = notes
            self.payments = payments
            self.charges = charges
            self.costs = costs
            self.contracts = contracts
            self.pocs = pocs
            self.orderHighPriorityNote = orderHighPriorityNote
            self.accountHighPriorityNote = accountHighPriorityNote
        }
        
    }
    
#if canImport(CodyFire)
    /// AI tool: `custCommercialTrips.getTrip`
    /// Retrieves trip for the component.
    /// Availability defaults to `true`; full contract and Skyline usage notes are in `AIToolCatalog`.
    public static func getTrip(
        tripId: HybridIdentifier
    ) -> APIRequest<APIResponseGeneric<GetTripResponse>> {
        request("getTrip", payload: GetTripRequest(
            tripId: tripId
        ))
            .method(.post)
    }
#endif
    
}
