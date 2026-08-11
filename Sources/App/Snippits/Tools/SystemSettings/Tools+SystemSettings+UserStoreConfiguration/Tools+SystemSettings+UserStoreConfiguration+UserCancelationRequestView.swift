//
//  Tools+SystemSettings+UserStoreConfiguration+UserCancelationRequestView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {

    final class UserCancelationRequestView: Div {

        override class var name: String { "div" }

        private let store: CustStore
        private let user: CustUsername
        private let payload: CustUsernameComponents.RequestUserCancelationResponse
        private let onCanceled: () -> Void

        private struct ConflictItem: Hashable {
            let id: String
            let title: String
            let value: String
            let detail: String
        }

        private enum CustodianChannel {
            case supervision
            case orders
            case followups
            case sales
            case tasks
            case inventory
        }

        @State private var supervisionCustodian: CustUsername? = nil
        @State private var ordersCustodian: CustUsername? = nil
        @State private var followupsCustodian: CustUsername? = nil
        @State private var salesCustodian: CustUsername? = nil
        @State private var tasksCustodian: CustUsername? = nil
        @State private var inventoryCustodian: CustUsername? = nil
        @State private var actionTitle = "Evaluando solicitud"
        @State private var actionMessage = "Verificando responsabilidades y custodios requeridos."
        @State private var actionSymbol = "!"
        @State private var canProceed = false
        @State private var isSubmitting = false

        init(
            store: CustStore,
            user: CustUsername,
            payload: CustUsernameComponents.RequestUserCancelationResponse,
            onCanceled: @escaping () -> Void = {}
        ) {
            self.store = store
            self.user = user
            self.payload = payload
            self.onCanceled = onCanceled
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        private var displayName: String {
            let values = [
                user.firstName,
                user.secondName,
                user.lastName,
                user.secondLastName
            ].filter { !$0.isEmpty }

            return values.isEmpty ? user.username : values.joined(separator: " ")
        }

        private var payloadMatchesUser: Bool {
            payload.userId == user.id
        }

        private var blockingConflicts: [ConflictItem] {
            [
                payload.storeSupervisor.map {
                    ConflictItem(
                        id: "storeSupervisor",
                        title: "Supervisor de tienda",
                        value: $0.name,
                        detail: "Cambie el supervisor de la tienda antes de cancelar al usuario."
                    )
                },
                payload.balance.map {
                    ConflictItem(
                        id: "balance",
                        title: "Balance pendiente",
                        value: "$\($0.formatMoney)",
                        detail: "El balance del usuario debe quedar en cero antes de continuar."
                    )
                },
                countConflict(
                    "commissions",
                    "Comisiones pendientes",
                    payload.commissions,
                    "Concilie las comisiones del usuario antes de continuar."
                ),
                countConflict(
                    "productionPoints",
                    "Puntos de producción",
                    payload.productionPoints,
                    "Procese o concilie los puntos de producción antes de continuar."
                )
            ].compactMap { $0 }
        }

        private var supervisionConflicts: [ConflictItem] {
            [
                countConflict("projects", "Proyectos", payload.projects, "Proyectos que requieren un nuevo supervisor."),
                countConflict("routes", "Rutas", payload.routes, "Rutas supervisadas o asignadas al usuario.")
            ].compactMap { $0 }
        }

        private var orderConflicts: [ConflictItem] {
            [
                countConflict("orders", "Órdenes", payload.orders, "Órdenes activas que requieren un nuevo custodio."),
                countConflict("rentals", "Rentas", payload.rentals, "Rentas activas asignadas al usuario."),
                countConflict("projectItems", "Actividades de proyecto", payload.projectItems, "Actividades de proyecto que requieren un nuevo custodio.")
            ].compactMap { $0 }
        }

        private var followupConflicts: [ConflictItem] {
            [
                countConflict("followups", "Seguimientos", payload.followups, "Seguimientos abiertos que requieren un nuevo responsable.")
            ].compactMap { $0 }
        }

        private var salesConflicts: [ConflictItem] {
            [
                countConflict("sales", "Ventas", payload.sales, "Ventas abiertas que requieren un nuevo custodio.")
            ].compactMap { $0 }
        }

        private var taskConflicts: [ConflictItem] {
            [
                countConflict("jobPosts", "Puestos y vacantes", payload.jobPosts, "Puestos operativos que requieren un nuevo responsable."),
                countConflict("tasks", "Tareas", payload.tasks, "Tareas activas asignadas al usuario."),
                countConflict("cronTasks", "Tareas programadas", payload.cronTasks, "Procesos recurrentes que requieren un nuevo custodio.")
            ].compactMap { $0 }
        }

        private var inventoryConflicts: [ConflictItem] {
            [
                countConflict("inventory", "Inventario", payload.inventory, "Artículos de inventario bajo custodia."),
                countConflict("commercialAssets", "Activos comerciales", payload.commercialAssets, "Activos comerciales bajo resguardo."),
                countConflict("generalInventory", "Inventario general", payload.generalInventory, "Herramientas o activos generales asignados.")
            ].compactMap { $0 }
        }

        private var transferConflictCount: Int {
            supervisionConflicts.count +
                orderConflicts.count +
                followupConflicts.count +
                salesConflicts.count +
                taskConflicts.count +
                inventoryConflicts.count
        }

        private var supportedConflictCount: Int {
            blockingConflicts.count + transferConflictCount
        }

        private var missingCustodianCount: Int {
            var count = 0
            if !supervisionConflicts.isEmpty && supervisionCustodian == nil { count += 1 }
            if !orderConflicts.isEmpty && ordersCustodian == nil { count += 1 }
            if !followupConflicts.isEmpty && followupsCustodian == nil { count += 1 }
            if !salesConflicts.isEmpty && salesCustodian == nil { count += 1 }
            if !taskConflicts.isEmpty && tasksCustodian == nil { count += 1 }
            if !inventoryConflicts.isEmpty && inventoryCustodian == nil { count += 1 }
            return count
        }

        private lazy var statusView = Div {
            Span(self.$actionSymbol)
                .class(Class(TCUserCancelationRequestClass.warningIcon))
            Div {
                Strong(self.$actionTitle)
                Span(self.$actionMessage)
            }
        }
            .class(Class(TCUserCancelationRequestClass.warning))

        private lazy var proceedAction = Div {
            Span(self.$isSubmitting.map {
                $0 ? "Procesando cancelación..." : "Proceder con cancelación"
            })
        }
            .class(Class(TCCrystalSurfaceClass.goodButton))
            .class(Class(TCUserCancelationRequestClass.proceedAction))
            .onClick {
                self.requestCancelation()
            }

        @DOM override var body: DOM.Content {
            Div {
                Div {
                    Div {
                        Span("Transferencia de responsabilidades")
                            .class(Class(TCUserCancelationRequestClass.eyebrow))
                        H2("Cancelación de usuario")
                        Span(!self.payloadMatchesUser
                            ? "La respuesta del servidor no coincide con el usuario seleccionado."
                            : (self.supportedConflictCount > 0
                                ? "\(self.supportedConflictCount) categorías requieren atención."
                                : "No hay responsabilidades compatibles pendientes."))
                    }
                        .class(Class(TCUserCancelationRequestClass.headerCopy))

                    Img()
                        .closeButton(.subView)
                        .class(Class(TCUserCancelationRequestClass.close))
                        .onClick {
                            guard !self.isSubmitting else { return }
                            self.remove()
                        }
                }
                    .class(Class(TCUserCancelationRequestClass.header))

                Div {
                    self.statusView

                    Div {
                        self.sectionTitle("Usuario seleccionado", "Identidad que será cancelada")
                        Div {
                            self.detail("Nombre", self.displayName)
                            self.detail("Usuario", self.user.username)
                            self.detail("ID", self.user.MID)
                            self.detail("Estado", self.user.status.description)
                            self.detail("Nivel operativo", self.user.role.description)
                            self.detail("Tienda", self.store.name)
                        }
                            .class(Class(TCUserCancelationRequestClass.details))
                    }
                        .class(Class(TCUserCancelationRequestClass.card))

                    if !self.blockingConflicts.isEmpty {
                        self.blockerSection(self.blockingConflicts)
                    }

                    if !self.supervisionConflicts.isEmpty {
                        self.custodianSection(
                            channel: .supervision,
                            title: "Supervisión de proyectos y rutas",
                            subtitle: "El reemplazo debe tener nivel de supervisor o superior",
                            items: self.supervisionConflicts,
                            selection: self.$supervisionCustodian
                        )
                    }

                    if !self.orderConflicts.isEmpty {
                        self.custodianSection(
                            channel: .orders,
                            title: "Órdenes, rentas y proyectos",
                            subtitle: "Seleccione el nuevo custodio operativo",
                            items: self.orderConflicts,
                            selection: self.$ordersCustodian
                        )
                    }

                    if !self.followupConflicts.isEmpty {
                        self.custodianSection(
                            channel: .followups,
                            title: "Seguimientos",
                            subtitle: "Seleccione un usuario con perfil de ventas",
                            items: self.followupConflicts,
                            selection: self.$followupsCustodian
                        )
                    }

                    if !self.salesConflicts.isEmpty {
                        self.custodianSection(
                            channel: .sales,
                            title: "Ventas",
                            subtitle: "Seleccione un usuario con perfil de ventas",
                            items: self.salesConflicts,
                            selection: self.$salesCustodian
                        )
                    }

                    if !self.taskConflicts.isEmpty {
                        self.custodianSection(
                            channel: .tasks,
                            title: "Puestos y tareas",
                            subtitle: "Seleccione el nuevo responsable operativo",
                            items: self.taskConflicts,
                            selection: self.$tasksCustodian
                        )
                    }

                    if !self.inventoryConflicts.isEmpty {
                        self.custodianSection(
                            channel: .inventory,
                            title: "Inventario y activos",
                            subtitle: "Seleccione el nuevo custodio de recursos",
                            items: self.inventoryConflicts,
                            selection: self.$inventoryCustodian
                        )
                    }

                    if self.supportedConflictCount == 0 && self.payloadMatchesUser {
                        Div {
                            Strong("Sin responsabilidades procesables pendientes")
                            Span("Los campos no contemplados en esta etapa se ignoran temporalmente.")
                        }
                            .class(Class(TCUserCancelationRequestClass.emptyState))
                    }
                }
                    .class(Class(TCUserCancelationRequestClass.content))

                Div {
                    Div {
                        Strong(self.$actionTitle)
                        Span(self.$actionMessage)
                    }

                    Div {
                        Div("Cerrar")
                            .class(Class(TCUserCancelationRequestClass.closeAction))
                            .onClick {
                                guard !self.isSubmitting else { return }
                                self.remove()
                            }

                        self.proceedAction
                    }
                        .class(Class(TCUserCancelationRequestClass.footerActions))
                }
                    .class(Class(TCUserCancelationRequestClass.footer))
            }
                .class(Class(TCUserCancelationRequestClass.shell))
        }

        override func buildUI() {
            super.buildUI()

            TCCrystalSurfaceTheme.apply(to: self, variant: .customerCreation)
            TCUserCancelationRequestTheme.apply(to: self)

            position(.fixed)
            width(100.percent)
            height(100.percent)
            left(0.px)
            top(0.px)
            zIndex(9999999)

            refreshActionState()
        }

        private func sectionTitle(_ title: String, _ subtitle: String) -> Div {
            Div {
                Strong(title)
                Span(subtitle)
            }
                .class(Class(TCUserCancelationRequestClass.sectionTitle))
        }

        private func blockerSection(_ items: [ConflictItem]) -> Div {
            Div {
                self.sectionTitle(
                    "Bloqueos que impiden continuar",
                    "Resuelva estos elementos y solicite nuevamente la cancelación"
                )
                Div {
                    ForEach(items) { item in
                        self.conflictRow(item)
                    }
                }
                    .class(Class(TCUserCancelationRequestClass.conflictGrid))
            }
                .class(Class(TCUserCancelationRequestClass.card))
                .class(Class(TCUserCancelationRequestClass.blockerCard))
        }

        private func custodianSection(
            channel: CustodianChannel,
            title: String,
            subtitle: String,
            items: [ConflictItem],
            selection: State<CustUsername?>
        ) -> Div {
            Div {
                self.sectionTitle(title, subtitle)
                Div {
                    ForEach(items) { item in
                        self.conflictRow(item)
                    }
                }
                    .class(Class(TCUserCancelationRequestClass.conflictGrid))

                Div {
                    Div {
                        Span("Nuevo custodio")
                        Strong(selection.map { $0?.username ?? "Seleccionar otro usuario" })
                        Span(selection.map {
                            guard let user = $0 else {
                                return "CustUsername activo de \(self.store.name)"
                            }
                            return "\(user.role.description) · \(user.MID)"
                        })
                    }
                    Span("Seleccionar")
                        .class(Class(TCUserCancelationRequestClass.selectBadge))
                }
                    .class(Class(TCUserCancelationRequestClass.custodianSelector))
                    .onClick {
                        guard !self.isSubmitting else { return }
                        self.selectCustodian(channel)
                    }
            }
                .class(Class(TCUserCancelationRequestClass.card))
        }

        private func conflictRow(_ item: ConflictItem) -> Div {
            Div {
                Div {
                    Strong(item.title)
                    Span(item.detail)
                }
                    .class(Class(TCUserCancelationRequestClass.conflictCopy))
                Span(item.value)
                    .class(Class(TCUserCancelationRequestClass.conflictValue))
            }
                .class(Class(TCUserCancelationRequestClass.conflictItem))
        }

        private func detail(_ label: String, _ value: String) -> Div {
            Div {
                Span(label)
                Strong(value.isEmpty ? "N/D" : value)
            }
                .class(Class(TCUserCancelationRequestClass.detail))
        }

        private func countConflict(
            _ id: String,
            _ title: String,
            _ value: Int?,
            _ detail: String
        ) -> ConflictItem? {
            guard let value else {
                return nil
            }

            return ConflictItem(
                id: id,
                title: title,
                value: value.toString,
                detail: detail
            )
        }

        private func selectCustodian(_ channel: CustodianChannel) {
            let selector = SelectCustUsernameView(
                type: .store(store.id),
                ignore: [user.id]
            ) { selectedUser in
                switch channel {
                case .supervision:
                    self.supervisionCustodian = selectedUser
                case .orders:
                    self.ordersCustodian = selectedUser
                case .followups:
                    self.followupsCustodian = selectedUser
                case .sales:
                    self.salesCustodian = selectedUser
                case .tasks:
                    self.tasksCustodian = selectedUser
                case .inventory:
                    self.inventoryCustodian = selectedUser
                }

                self.refreshActionState()
            }

            addToDom(selector, presentation: .glass)
        }

        private func refreshActionState() {
            statusView.removeClass(Class(TCUserCancelationRequestClass.statusReady))
            statusView.removeClass(Class(TCUserCancelationRequestClass.statusError))
            proceedAction.removeClass(Class(TCUserCancelationRequestClass.actionDisabled))

            if isSubmitting {
                actionSymbol = "…"
                actionTitle = "Cancelación en proceso"
                actionMessage = "Transfiriendo responsabilidades y cancelando la cuenta."
                canProceed = false
            } else if !payloadMatchesUser {
                actionSymbol = "×"
                actionTitle = "Prevalidación inválida"
                actionMessage = "Cierre esta vista y solicite nuevamente los datos del usuario."
                canProceed = false
                statusView.class(Class(TCUserCancelationRequestClass.statusError))
            } else if !blockingConflicts.isEmpty {
                actionSymbol = "×"
                actionTitle = "Cancelación bloqueada"
                actionMessage = "Resuelva los saldos o cambie el supervisor de tienda antes de continuar."
                canProceed = false
                statusView.class(Class(TCUserCancelationRequestClass.statusError))
            } else if missingCustodianCount > 0 {
                actionSymbol = "!"
                actionTitle = "Faltan custodios"
                actionMessage = "Seleccione \(missingCustodianCount) reemplazo(s) para transferir las responsabilidades activas."
                canProceed = false
            } else {
                actionSymbol = "✓"
                actionTitle = "Solicitud lista"
                actionMessage = transferConflictCount > 0
                    ? "Los custodios están completos; puede proceder con la cancelación."
                    : "No hay responsabilidades procesables que deban transferirse."
                canProceed = true
                statusView.class(Class(TCUserCancelationRequestClass.statusReady))
            }

            if !canProceed {
                proceedAction.class(Class(TCUserCancelationRequestClass.actionDisabled))
            }
        }

        private func requestCancelation() {
            refreshActionState()

            guard canProceed, !isSubmitting else {
                return
            }

            let confirmation = ConfirmationView(
                type: .yesNo,
                title: "Cancelar usuario",
                message: "Se transferirán las responsabilidades seleccionadas y la cuenta quedará cancelada. ¿Desea continuar?"
            ) { isConfirmed, _ in
                guard isConfirmed else { return }
                self.performCancelation()
            }

            addToDom(confirmation, presentation: .glass)
        }

        private func performCancelation() {
            refreshActionState()

            guard canProceed, !isSubmitting else {
                return
            }

            isSubmitting = true
            refreshActionState()

            let routeFallbackId = payload.routes == nil ? nil : supervisionCustodian?.id

            API.custUsernameV1.userCancelation(
                userId: user.id,
                supervisorUserId: supervisionCustodian?.id,
                ordersWorkUserId: ordersCustodian?.id ?? routeFallbackId,
                followupsWorkUserId: followupsCustodian?.id,
                salesWorkUserId: salesCustodian?.id,
                tasksWorkUserId: tasksCustodian?.id,
                inventoryWorkUserId: inventoryCustodian?.id
            ) { resp in
                self.isSubmitting = false

                guard let resp else {
                    self.refreshActionState()
                    showError(.comunicationError, "No se pudo comunicar con el servidor")
                    return
                }

                guard resp.status == .ok else {
                    self.refreshActionState()
                    showError(.generalError, resp.msg)
                    return
                }

                showSuccess(.operacionExitosa, "El usuario fue cancelado y sus responsabilidades fueron transferidas")
                self.onCanceled()
                self.remove()
            }
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $supervisionCustodian.removeAllListeners()
            $ordersCustodian.removeAllListeners()
            $followupsCustodian.removeAllListeners()
            $salesCustodian.removeAllListeners()
            $tasksCustodian.removeAllListeners()
            $inventoryCustodian.removeAllListeners()
            $actionTitle.removeAllListeners()
            $actionMessage.removeAllListeners()
            $actionSymbol.removeAllListeners()
            $canProceed.removeAllListeners()
            $isSubmitting.removeAllListeners()
        }
    }
}
