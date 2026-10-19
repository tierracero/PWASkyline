import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustAssetsView {

    final class CustAssetsQuickDepartmentView: Div {

        override class var name: String { "div" }

        let viewType: InitiateAssetItemViewType

        @State private var departments: [CustAssetDeps]

        @State private var sections: [CustCommercialAssetsSection]

        @State private var subSections: [CustCommercialAssetsSubSection]

        init(
            viewType: InitiateAssetItemViewType,
            departments: [CustAssetDeps],
            sections: [CustCommercialAssetsSection],
            subSections: [CustCommercialAssetsSubSection]
        ) {

            self.viewType = viewType
            self.departments = departments
            self.sections = sections
            self.subSections = subSections
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State var isLoading: Bool = false

        @State var selectedCategory: CustAssetCats?

        private var pendingDepartmentLoads = 0

        private var departmentLoadToken = UUID()

        private lazy var departmentList = Div {

            emptyState(
                "No hay departamentos",
                "Agregue un departamento antes de crear activos."
            )
            .display(self.$departments.map{ !$0.isEmpty ? .none : .grid })
            .hidden(self.$departments.map{ !$0.isEmpty })
            .custom("height", "calc(100% - 42px)")

            Div {

                ForEach(self.$departments) { department in

                    VBox(.interactive) {
                        
                            Img()
                                .src(self.avatarSource(department.coverLandscape, destination: .assetDepartment))
                                
                                .custom("border", "1px solid rgba(66, 183, 245, 0.28)")
                                .custom("background", "rgba(3, 18, 32, 0.68)")
                                .custom("border-radius", "9px")
                                .custom("flex", "0 0 48px")
                                .objectFit(.contain)
                                .height(48.px)
                                .width(48.px)

                            Div {
                                Div(department.name)
                                    .class(.oneLineText)
                                    .fontWeight(.bold)

                                UMinorTitle(
                                    department.smallDescription.isEmpty
                                        ? "Sin descripción"
                                        : department.smallDescription
                                )
                                .class(.oneLineText)
                                .marginTop(2.px)
                            }
                            .custom("min-width", "0")
                            .custom("flex", "1 1 auto")

                            Span( "›" )
                                .color(.gray)
                                
                        }
                        // .backgroundColor(Color(r: 10, g: 22, b: 34, a: 0.6).important)
                        // .borderColor(Color(r: 66, g: 183, b: 245, a: 0.2).important)
                        // .custom("justify-content", "space-between")
                        // .custom("align-items", "center")
                        // .custom("gap", "8px")
                        // .display(.flex)
                        // .onClick {
                        //     self.loadDepartment(department)
                        // }
                
                    Div().height(7.px)
                }

            }
            .display(self.$departments.map{ $0.isEmpty ? .none : .block })
            .hidden(self.$departments.map{ $0.isEmpty })
            .custom("height", "calc(100% - 42px)")

        }
            .custom("height", "calc(100% - 42px)")
            .custom("align-content", "start")
            .custom("gap", "12px")



        @DOM override var body: DOM.Content {

            VPopUp(.compact) {

                VTitle("Control de Activos", icon: "commertial_assets_icon.png") {
                    USmallTitle("Activos \(self.viewType.relationType.description)")
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.full) {
                        VBox(.raised) {
                            Div {
                                UTitle("Departamentos")
                                USmallButton("+ Agregar")
                                    .onClick {
                                        self.createDepartment()
                                    }
                            }
                            .display(.flex)
                            .custom("align-items", "center")
                            .custom("justify-content", "space-between")
                            .custom("gap", "10px")

                            self.departmentList
                                .marginTop(12.px)
                        }
                        .custom("height", "calc(100% - 45px)")
                        // .height(100.percent)
                        .overflow(.auto)
                    }
                    .height(100.percent)
                    .custom("min-height", "0")
                    .custom("grid-template-rows", "minmax(0, 1fr)")
                    .custom("align-content", "stretch")

                }
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-content", "stretch")
                .custom("align-items", "stretch")
                .custom("min-height", "0")
                .height(100.percent)
            }
        }

        override func buildUI() {
            super.buildUI()

            TCCrystalSurfaceTheme.apply(to: self, variant: .assets)

            position(.absolute)
            width(100.percent)
            height(100.percent)
            left(0.px)
            top(0.px)
        }

        override func didAddToDOM() {
            super.didAddToDOM()
            
        }

        private func loadDepartment(_ department: CustAssetDeps) {

        }

        private func finishDepartmentLoad() {
            pendingDepartmentLoads = max(0, pendingDepartmentLoads - 1)
            if pendingDepartmentLoads == 0 {
                loadingView.hide()
            }
        }

        private func avatarSource(_ avatar: String?, destination: ImagePickerTo) -> String {
            let normalized = (avatar ?? "").purgeSpaces

            guard !normalized.isEmpty else {
                return "/skyline/media/tierraceroRoundLogoWhite.svg"
            }

            guard !normalized.hasPrefix("/") &&
                    !normalized.hasPrefix("http://") &&
                    !normalized.hasPrefix("https://") else {
                return normalized
            }

            return destination.url(
                url: custCatchUrl,
                pDir: pDir,
                isPreRegistration: false,
                accountType: custCatchAccountType
            ) + normalized
        }

        private func createDepartment() {
            addToDom(
                DepartmentEditor(
                    relationType: viewType.relationType,
                    relationId: viewType.relationId
                ) { department in
                    self.departments.append(department)
                    self.loadDepartment(department)
                }
            )
        }

        private func editDepartment(_ department: CustAssetDeps) {

            addToDom(
                DepartmentEditor(
                    relationType: viewType.relationType,
                    relationId: viewType.relationId, 
                    department: department
                ) { updated in
                    self.departments = self.departments.map { $0.id == updated.id ? updated : $0 }

                }
            )
        }

    }


}

