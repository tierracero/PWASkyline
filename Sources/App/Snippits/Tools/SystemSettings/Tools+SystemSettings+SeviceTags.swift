//
//  Tools+SystemSettings+SeviceTags.swift
//  
//
//  Created by Victor Cantu on 9/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings {
    
    class SeviceTags: Div {
        
        override class var name: String { "div" }
        
        /// object, helth, food, delivery, service, product
        @State var typeOfServiceObject: ConfigTypeOfServiceObject

        /// IMEI or Serial Number
        @State var idTagName: String
        /// Description of text
        @State var idTagDescr: String
        /// Example text for tag
        @State var idTagPlaceholder: String

        /// Secondery ID tag
        @State var secondIDTagRequiered: Bool
        /// Poliza de garantia
        @State var secondIDTagName: String
        /// Description of text
        @State var secondIDTagDescr: String
        /// Example text for tag
        @State var secondIDTagPlaceholder: String

        /// Use special interface  for  tag1 (brand)  and tag2 (model) input
        @State var useBrandModelMode: Bool

        @State var tag1: Bool
        @State var tag1Name: String
        @State var tag1Placeholder: String

        @State var tag2: Bool
        @State var tag2Name: String
        @State var tag2Placeholder: String

        @State var tag3: Bool
        @State var tag3Name: String
        @State var tag3Placeholder: String

        @State var tag4: Bool
        @State var tag4Name: String
        @State var tag4Placeholder: String

        @State var tag5: Bool
        @State var tag5Name: String
        @State var tag5Placeholder: String

        @State var tag6: Bool
        @State var tag6Name: String
        @State var tag6Placeholder: String

        @State var checkTag1: Bool
        @State var checkTag1Name: String

        @State var checkTag2: Bool
        @State var checkTag2Name: String

        @State var checkTag3: Bool
        @State var checkTag3Name: String

        @State var checkTag4: Bool
        @State var checkTag4Name: String

        @State var checkTag5: Bool
        @State var checkTag5Name: String

        @State var checkTag6: Bool
        @State var checkTag6Name: String

        @State var tagDescrName: String
        @State var tagDescrPlaceholder: String

        @State var additionalMainTags: [ConfigOrderTags]

        @State var serviceMap: [String]

        @State var sideStatus: [ConfigServiceTagsSideStatus]

        @State var diagnosticResolutionActions: Bool

        init(
            configServiceTags: ConfigServiceTags
        ) {
            self.typeOfServiceObject = configServiceTags.typeOfServiceObject
            self.idTagName = configServiceTags.idTagName
            self.idTagDescr = configServiceTags.idTagDescr
            self.idTagPlaceholder = configServiceTags.idTagPlaceholder
            self.secondIDTagRequiered = configServiceTags.secondIDTagRequiered
            self.secondIDTagName = configServiceTags.secondIDTagName
            self.secondIDTagDescr = configServiceTags.secondIDTagDescr
            self.secondIDTagPlaceholder = configServiceTags.secondIDTagPlaceholder
            self.useBrandModelMode = configServiceTags.useBrandModelMode
            self.tag1 = configServiceTags.tag1
            self.tag1Name = configServiceTags.tag1Name
            self.tag1Placeholder = configServiceTags.tag1Placeholder
            self.tag2 = configServiceTags.tag2
            self.tag2Name = configServiceTags.tag2Name
            self.tag2Placeholder = configServiceTags.tag2Placeholder
            self.tag3 = configServiceTags.tag3
            self.tag3Name = configServiceTags.tag3Name
            self.tag3Placeholder = configServiceTags.tag3Placeholder
            self.tag4 = configServiceTags.tag4
            self.tag4Name = configServiceTags.tag4Name
            self.tag4Placeholder = configServiceTags.tag4Placeholder
            self.tag5 = configServiceTags.tag5
            self.tag5Name = configServiceTags.tag5Name
            self.tag5Placeholder = configServiceTags.tag5Placeholder
            self.tag6 = configServiceTags.tag6
            self.tag6Name = configServiceTags.tag6Name
            self.tag6Placeholder = configServiceTags.tag6Placeholder
            self.checkTag1 = configServiceTags.checkTag1
            self.checkTag1Name = configServiceTags.checkTag1Name
            self.checkTag2 = configServiceTags.checkTag2
            self.checkTag2Name = configServiceTags.checkTag2Name
            self.checkTag3 = configServiceTags.checkTag3
            self.checkTag3Name = configServiceTags.checkTag3Name
            self.checkTag4 = configServiceTags.checkTag4
            self.checkTag4Name = configServiceTags.checkTag4Name
            self.checkTag5 = configServiceTags.checkTag5
            self.checkTag5Name = configServiceTags.checkTag5Name
            self.checkTag6 = configServiceTags.checkTag6
            self.checkTag6Name = configServiceTags.checkTag6Name
            self.tagDescrName = configServiceTags.tagDescrName
            self.tagDescrPlaceholder = configServiceTags.tagDescrPlaceholder
            self.additionalMainTags = configServiceTags.additionalMainTags
            self.serviceMap = configServiceTags.serviceMap
            self.sideStatus = configServiceTags.sideStatus
            self.diagnosticResolutionActions = configServiceTags.diagnosticResolutionActions
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        lazy var typeOfServiceObjectSelect = Select()
            .class(.textFiledBlackDark)
            .width(95.percent)
            .onChange { _, select in
                if let type = ConfigTypeOfServiceObject(rawValue: select.text) {
                    self.typeOfServiceObject = type
                }
            }

        /// IMEI or Serial Number
        lazy var idTagNameField: InputText = InputText(self.$idTagName)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Identificador Primario [SERIE]")

        /// Description of text
        lazy var idTagDescrField: InputText = InputText(self.$idTagDescr)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texo descriptivo")
            
        /// Example text for tag
        lazy var idTagPlaceholderField: InputText = InputText(self.$idTagPlaceholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto ejemplo")
            

        /// Secondery ID tag
        lazy var secondIDTagRequieredCheckbox = InputCheckbox().toggle(self.$secondIDTagRequiered)
        /// Poliza de garantia
        lazy var secondIDTagNameField: InputText = InputText(self.$secondIDTagName)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Identificador Secundario [POLISA]")
            
        /// Description of text
        lazy var secondIDTagDescrField: InputText = InputText(self.$secondIDTagDescr)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto descriptivo")
            
        /// Example text for tag
        lazy var secondIDTagPlaceholderField: InputText = InputText(self.$secondIDTagPlaceholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto ejemplo")
            

        /// Use special interface  for  tag1 (brand)  and tag2 (model) input
        lazy var useBrandModelModeCheckbox = InputCheckbox().toggle(self.$useBrandModelMode)

        lazy var tag1Checkbox = InputCheckbox().toggle(self.$tag1)
        lazy var tag1NameField: InputText = InputText(self.$tag1Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Campo Uno [MARCA]")
            
        lazy var tag1PlaceholderField: InputText = InputText(self.$tag1Placeholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto de ayuda")


        lazy var tag2Checkbox = InputCheckbox().toggle(self.$tag2)
        lazy var tag2NameField: InputText = InputText(self.$tag2Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Campo Dos [MODELO]")

        lazy var tag2PlaceholderField: InputText = InputText(self.$tag2Placeholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto de ayuda")
            

        lazy var tag3Checkbox = InputCheckbox().toggle(self.$tag3)
        lazy var tag3NameField: InputText = InputText(self.$tag3Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Campo Tres [TIPO]")
            
        lazy var tag3PlaceholderField: InputText = InputText(self.$tag3Placeholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto de ayuda")
            

        lazy var tag4Checkbox = InputCheckbox().toggle(self.$tag4)
        lazy var tag4NameField: InputText = InputText(self.$tag4Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Campo Cuatro [Color / Observaciones]")
            
        lazy var tag4PlaceholderField: InputText = InputText(self.$tag4Placeholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto de ayudo")
            

        lazy var tag5Checkbox = InputCheckbox().toggle(self.$tag5)
        lazy var tag5NameField: InputText = InputText(self.$tag5Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Campo Cinco")
            
        lazy var tag5PlaceholderField: InputText = InputText(self.$tag5Placeholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto de ayuda")
            

        lazy var tag6Checkbox = InputCheckbox().toggle(self.$tag6)
        lazy var tag6NameField: InputText = InputText(self.$tag6Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Campo Seis")
            
        lazy var tag6PlaceholderField: InputText = InputText(self.$tag6Placeholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Texto de ayuda")
            

        lazy var checkTag1Checkbox = InputCheckbox().toggle(self.$checkTag1)
        lazy var checkTag1NameField: InputText = InputText(self.$checkTag1Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Chekbox Uno")
            

        lazy var checkTag2Checkbox = InputCheckbox().toggle(self.$checkTag2)
        lazy var checkTag2NameField: InputText = InputText(self.$checkTag2Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Chekbox Dos")
            

        lazy var checkTag3Checkbox = InputCheckbox().toggle(self.$checkTag3)
        lazy var checkTag3NameField: InputText = InputText(self.$checkTag3Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Chekbox Tress")
            

        lazy var checkTag4Checkbox = InputCheckbox().toggle(self.$checkTag4)
        lazy var checkTag4NameField: InputText = InputText(self.$checkTag4Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Chekbox Four")
            

        lazy var checkTag5Checkbox = InputCheckbox().toggle(self.$checkTag5)
        lazy var checkTag5NameField: InputText = InputText(self.$checkTag5Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Chekbox Cinco")
            

        lazy var checkTag6Checkbox = InputCheckbox().toggle(self.$checkTag6)
        lazy var checkTag6NameField: InputText = InputText(self.$checkTag6Name)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Chekbox Seis")
            

        lazy var tagDescrNameField: InputText = InputText(self.$tagDescrName)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Descripcion De la Orden")
            
        lazy var tagDescrPlaceholderField: InputText = InputText(self.$tagDescrPlaceholder)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Testo de ayuda para descripcion de la orden")

        //lazy var additionalMainTags: [ConfigOrderTags]

        //lazy var serviceMap: [String]

        //lazy var sideStatus: [ConfigServiceTagsSideStatus]

        lazy var diagnosticResolutionActionsCheckbox = InputCheckbox().toggle(self.$diagnosticResolutionActions)

        @DOM override var body: DOM.Content {
            
                H3("Configuración de Etiquetas de Servicio").color(.lightBlueText)
                
                /* Categoria de cliente primario*/
                Div{
                    Div{
                        /* MARK: typeOfServiceObjectSelect */
                        Div{
                            Div{
                                H2("Tipo de Servicio")
                                .color(.darkGoldenRod)
                            }
                            .width(70.percent)
                            .float(.left)

                            Div{
                                self.typeOfServiceObjectSelect
                            }
                            .width(30.percent)
                            .float(.left)

                            Div().clear(.both).height(7.px)
                        }
                        
                        /* MARK: idTag */
                        Div{
                            Div{
                                H2("Identificador Primario")
                                .color(.darkGoldenRod)
                            }
                            Div().clear(.both).height(12.px)

                            Div{
                                Div{
                                    Label("Tipo de identificador primario")
                                }
                                .width(70.percent)
                                .float(.left)

                                Div{
                                    self.idTagNameField
                                }
                                .width(30.percent)
                                .float(.left)
                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: idTagDescrField */
                            Div{
                                Div{
                                    Label("Descripcion de  Identificador Primario")
                                }
                                .width(70.percent)
                                .float(.left)

                                Div{
                                    self.idTagDescrField
                                }
                                .width(30.percent)
                                .float(.left)
                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: idTagPlaceholderField */
                            Div{
                                Div{
                                    Label("Texto de ayuda Identifocador Primario")
                                }
                                .width(70.percent)
                                .float(.left)

                                Div{
                                    self.idTagPlaceholderField
                                }
                                .width(30.percent)
                                .float(.left)
                            }
                            Div().clear(.both).height(12.px)

                        }
                        
                        /* MARK: Checkboxs */


                        /* MARK: idTag2 */
                        Div{
                            Div{
                                self.secondIDTagRequieredCheckbox
                                .float(.right)
                                H2("Identificador Secundario")
                                .color(.darkGoldenRod)
                            }
                            Div().clear(.both).height(7.px)
                            
                            Div{
                                Div{
                                    Label("Tipo de identificador secundario")
                                }
                                .width(70.percent)
                                .float(.left)

                                Div{
                                    self.secondIDTagNameField
                                    .color(self.$secondIDTagRequiered.map{  !$0 ? .gray : .white })
                                    .disabled(self.$secondIDTagRequiered.map{  !$0 })
                                }
                                .width(30.percent)
                                .float(.left)
                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: idTagDescrField */
                            Div{
                                Div{
                                    Label("Descripcion de  Identificador Secundario")
                                }
                                .width(70.percent)
                                .float(.left)

                                Div{
                                    self.secondIDTagDescrField
                                    .color(self.$secondIDTagRequiered.map{  !$0 ? .gray : .white })
                                    .disabled(self.$secondIDTagRequiered.map{  !$0 })
                                }
                                .width(30.percent)
                                .float(.left)
                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: idTagPlaceholderField */
                            Div{
                                Div{
                                    Label("Texto de ayuda Identifocador Secundario")
                                }
                                .width(70.percent)
                                .float(.left)

                                Div{
                                    self.secondIDTagPlaceholderField
                                }
                                .width(30.percent)
                                .float(.left)
                            }
                            Div().clear(.both).height(12.px)

                        }
                        
                        
                        Div{
                            H2("Checkboxes")
                            .color(.darkGoldenRod)
                        }
                        Div().clear(.both).height(12.px)
                        
                        /* MARK: Checkboxs One */
                        Div{

                            Div{
                                self.checkTag1Checkbox
                                .float(.right)
                                H3("Checkbox Uno")
                            }
                            Div().clear(.both).height(7.px)

                            Div{
                                Label("Valor del checkbox")
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                self.checkTag1NameField
                                .color(self.$checkTag1.map{  !$0 ? .gray : .white })
                                .disabled(self.$checkTag1.map{  !$0 })
                            }
                            .width(50.percent)
                            .align(.right)
                            .float(.left)

                            Div().clear(.both).height(3.px)

                        }
                        Div().clear(.both).height(12.px)

                        /* MARK: Checkboxs Two*/
                        Div{

                            Div{
                                self.checkTag2Checkbox
                                .float(.right)
                                H3("Checkbox Dos")
                            }
                            Div().clear(.both).height(7.px)

                            Div{
                                Label("Valor del checkbox")
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                self.checkTag2NameField
                                .color(self.$checkTag2.map{  !$0 ? .gray : .white })
                                .disabled(self.$checkTag2.map{  !$0 })
                            }
                            .width(50.percent)
                            .align(.right)
                            .float(.left)

                            Div().clear(.both).height(3.px)

                        }
                        Div().clear(.both).height(12.px)

                        /* MARK: Checkboxs Three*/
                        Div{

                            Div{
                                self.checkTag3Checkbox
                                .float(.right)
                                H3("Checkbox Tres")
                            }
                            Div().clear(.both).height(7.px)

                            Div{
                                Label("Valor del checkbox")
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                self.checkTag3NameField
                                .color(self.$checkTag3.map{  !$0 ? .gray : .white })
                                .disabled(self.$checkTag3.map{  !$0 })
                            }
                            .width(50.percent)
                            .align(.right)
                            .float(.left)

                            Div().clear(.both).height(3.px)

                        }
                        Div().clear(.both).height(12.px)

                        /* MARK: Checkboxs Four*/
                        Div{

                            Div{
                                self.checkTag4Checkbox
                                .float(.right)
                                H3("Checkbox Cuatro")
                            }
                            Div().clear(.both).height(7.px)

                            Div{
                                Label("Valor del checkbox")
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                self.checkTag4NameField
                                .color(self.$checkTag4.map{  !$0 ? .gray : .white })
                                .disabled(self.$checkTag4.map{  !$0 })
                            }
                            .width(50.percent)
                            .align(.right)
                            .float(.left)

                            Div().clear(.both).height(3.px)

                        }
                        Div().clear(.both).height(12.px)

                        /* MARK: Checkboxs Five*/
                        Div{

                            Div{
                                self.checkTag5Checkbox
                                .float(.right)
                                H3("Checkbox Cinco")
                            }
                            Div().clear(.both).height(7.px)

                            Div{
                                Label("Valor del checkbox")
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                self.checkTag5NameField
                                .color(self.$checkTag5.map{  !$0 ? .gray : .white })
                                .disabled(self.$checkTag5.map{  !$0 })
                            }
                            .width(50.percent)
                            .align(.right)
                            .float(.left)

                            Div().clear(.both).height(3.px)

                        }
                        Div().clear(.both).height(12.px)

                        /* MARK: Checkboxs Seis*/
                        Div{

                            Div{
                                self.checkTag6Checkbox
                                .float(.right)
                                H3("Checkbox Seis")
                            }
                            Div().clear(.both).height(7.px)

                            Div{
                                Label("Valor del checkbox")
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                self.checkTag6NameField
                                .color(self.$checkTag6.map{  !$0 ? .gray : .white })
                                .disabled(self.$checkTag6.map{  !$0 })
                            }
                            .width(50.percent)
                            .align(.right)
                            .float(.left)

                            Div().clear(.both).height(3.px)

                        }
                        Div().clear(.both).height(12.px)

                    }
                    .class(.oneHalf)
                    .color(.white)

                    Div{

                            /* MARK: Tags */
                            Div{
                                Div{
                                    H2("Modo de Formulario")
                                    .color(.darkGoldenRod)
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{

                                    self.useBrandModelModeCheckbox
                                    .marginLeft(7.px)
                                    .float(.right)

                                    H2("Seleccionador")

                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)
                            }
                            Div().clear(.both).height(12.px)

                            Div{
                                H2("Campos de formulario")
                                .color(.darkGoldenRod)
                            }
                            Div().clear(.both).height(12.px)
                            
                            /* MARK: Tag1 */
                            Div{

                                Div{
                                    self.tag1Checkbox
                                    .float(.right)
                                    H3("Campo Uno")
                                }
                                Div().clear(.both).height(7.px)

                                /* MARK:  NAME*/

                                Div{
                                    Label("Nombre del campo")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag1NameField
                                    .color(self.$tag1.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag1.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                                /* MARK:  PLACEHOLDER*/
                                
                                Div{
                                    Label("Texto de Ayuda")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag1PlaceholderField
                                    .color(self.$tag1.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag1.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: Tag2 */
                            Div{

                                Div{
                                    self.tag2Checkbox
                                    .float(.right)
                                    H3("Campo Dos")
                                }
                                Div().clear(.both).height(7.px)

                                /* MARK:  NAME*/

                                Div{
                                    Label("Nombre del campo")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag2NameField
                                    .color(self.$tag1.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag1.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                                /* MARK:  PLACEHOLDER*/
                                
                                Div{
                                    Label("Texto de Ayuda")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag2PlaceholderField
                                    .color(self.$tag2.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag2.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: Tag3 */
                            Div{

                                Div{
                                    self.tag3Checkbox
                                    .float(.right)
                                    H3("Campo Tres")
                                }
                                Div().clear(.both).height(7.px)

                                /* MARK:  NAME*/

                                Div{
                                    Label("Nombre del campo")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag3NameField
                                    .color(self.$tag3.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag3.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                                /* MARK:  PLACEHOLDER*/
                                
                                Div{
                                    Label("Texto de Ayuda")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag3PlaceholderField
                                    .color(self.$tag3.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag3.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: Tag4 */
                            Div{

                                Div{
                                    self.tag4Checkbox
                                    .float(.right)
                                    H3("Campo Cuatro")
                                }
                                Div().clear(.both).height(7.px)

                                /* MARK:  NAME*/

                                Div{
                                    Label("Nombre del campo")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag4NameField
                                    .color(self.$tag4.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag4.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                                /* MARK:  PLACEHOLDER*/
                                
                                Div{
                                    Label("Texto de Ayuda")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag4PlaceholderField
                                    .color(self.$tag4.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag4.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: Tag5 */
                            Div{

                                Div{
                                    self.tag5Checkbox
                                    .float(.right)
                                    H3("Campo Cinco")
                                }
                                Div().clear(.both).height(7.px)

                                /* MARK:  NAME*/

                                Div{
                                    Label("Nombre del campo")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag5NameField
                                    .color(self.$tag5.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag5.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                                /* MARK:  PLACEHOLDER*/
                                
                                Div{
                                    Label("Texto de Ayuda")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag5PlaceholderField
                                    .color(self.$tag5.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag5.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                            }
                            Div().clear(.both).height(12.px)

                            /* MARK: Tag6 */
                            Div{

                                Div{
                                    self.tag6Checkbox
                                    .float(.right)
                                    H3("Campo Seis")
                                }
                                Div().clear(.both).height(7.px)

                                /* MARK:  NAME*/

                                Div{
                                    Label("Nombre del campo")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag6NameField
                                    .color(self.$tag6.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag6.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                                /* MARK:  PLACEHOLDER*/
                                
                                Div{
                                    Label("Texto de Ayuda")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tag6PlaceholderField
                                    .color(self.$tag6.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag6.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                            }
                            Div().clear(.both).height(12.px)

                            Div{
                                H2("Campo de Descripcíon")
                                .color(.darkGoldenRod)
                            }
                            Div().clear(.both).height(12.px)
                            
                            /* MARK: Description  Area */
                            Div{
                                /* MARK:  NAME*/

                                Div{
                                    Label("Nombre del campo")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tagDescrNameField
                                    .color(self.$tag1.map{  !$0 ? .gray : .white })
                                    .disabled(self.$tag1.map{  !$0 })
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                                /* MARK:  PLACEHOLDER*/
                                
                                Div{
                                    Label("Texto de Ayuda")
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.tagDescrPlaceholderField
                                }
                                .width(50.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both).height(3.px)

                            }
                            Div().clear(.both).height(12.px)
                    }
                    .class(.oneHalf)
                    .color(.white)
                }
            
                
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
            
            //ConfigTypeOfServiceObject

            ConfigTypeOfServiceObject.allCases.forEach { item in
                typeOfServiceObjectSelect.appendChild(Option(item.description).value(item.rawValue))
            }


        }
        

        func saveData() {

            // ID Tag One
            if idTagName.isEmpty {
                showError(.campoRequerido, .requierdValid(""), .short)
                idTagNameField.select()
                return
            }

            if idTagDescr.isEmpty {
                showError(.campoRequerido, .requierdValid(""), .short)
                idTagDescrField.select()
                return
            }

            if idTagPlaceholder.isEmpty {
                showError(.campoRequerido, .requierdValid(""), .short)
                idTagPlaceholderField.select()
                return
            }

            // ID Tag Two
            if secondIDTagRequiered {

                if secondIDTagName.isEmpty {
                    showError(.campoRequerido, .requierdValid(""), .short)
                    secondIDTagNameField.select()
                    return
                }

                if secondIDTagDescr.isEmpty {
                    showError(.campoRequerido, .requierdValid(""), .short)
                    secondIDTagDescrField.select()
                    return
                }

                if secondIDTagPlaceholder.isEmpty {
                    showError(.campoRequerido, .requierdValid(""), .short)
                    secondIDTagPlaceholderField.select()
                    return
                }
            }

            // Tag One
            if tag1 {

                if tag1Name.isEmpty {
                    showError(.campoRequerido, .requierdValid("Nombre de Campo Uno"), .short)
                    tag1NameField.select()
                    return
                }

                if tag1Placeholder.isEmpty {
                    showError(.campoRequerido, .requierdValid("Texto de ayuda Campo Uno"), .short)
                    tag1PlaceholderField.select()
                    return
                }

            }

            // Tag Two
            if tag2 {

                if tag2Name.isEmpty {
                    showError(.campoRequerido, .requierdValid("Nombre de Campo Dos"), .short)
                    tag2NameField.select()
                    return
                }

                if tag2Placeholder.isEmpty {
                    showError(.campoRequerido, .requierdValid("Texto de ayuda Campo Dos"), .short)
                    tag2PlaceholderField.select()
                    return
                }

            }

            // Tag Three
            if tag3 {

                if tag3Name.isEmpty {
                    showError(.campoRequerido, .requierdValid("Nombre de Campo Tres"), .short)
                    tag3NameField.select()
                    return
                }

                if tag3Placeholder.isEmpty {
                    showError(.campoRequerido, .requierdValid("Texto de ayuda Campo Tres"), .short)
                    tag3PlaceholderField.select()
                    return
                }

            }

            // Tag Four
            if tag4 {

                if tag4Name.isEmpty {
                    showError(.campoRequerido, .requierdValid("Nombre de Campo Cuatro"), .short)
                    tag4NameField.select()
                    return
                }

                if tag4Placeholder.isEmpty {
                    showError(.campoRequerido, .requierdValid("Texto de ayuda Campo Cuatro"), .short)
                    tag4PlaceholderField.select()
                    return
                }

            }

            // Tag Five
            if tag5 {

                if tag5Name.isEmpty {
                    showError(.campoRequerido, .requierdValid("Nombre de Campo Cinco"), .short)
                    tag5NameField.select()
                    return
                }

                if tag5Placeholder.isEmpty {
                    showError(.campoRequerido, .requierdValid("Texto de ayuda Campo Cinco"), .short)
                    tag5PlaceholderField.select()
                    return
                }

            }

            // Tag Six
            if tag6 {

                if tag6Name.isEmpty {
                    showError(.campoRequerido, .requierdValid("Nombre de Campo Seis"), .short)
                    tag6NameField.select()
                    return
                }

                if tag6Placeholder.isEmpty {
                    showError(.campoRequerido, .requierdValid("Texto de ayuda Campo Seis"), .short)
                    tag6PlaceholderField.select()
                    return
                }

            }

            // Checkbox One
            if checkTag1 && checkTag1Name.isEmpty{
                showError(.campoRequerido, .requierdValid("Nombre Checkbox Uno"), .short)
                checkTag1NameField.select()
                return
            }

            // Checkbox Two
            if checkTag2 && checkTag2Name.isEmpty {
                showError(.campoRequerido, .requierdValid("Nombre Checkbox Dos"), .short)
                checkTag2NameField.select()
                return
            }

            // Checkbox Three
            if checkTag3 && checkTag3Name.isEmpty{
                showError(.campoRequerido, .requierdValid("Nombre Checkbox Tres"), .short)
                checkTag3NameField.select()
                return
            }

            // Checkbox Four
            if checkTag4 && checkTag4Name.isEmpty {
                showError(.campoRequerido, .requierdValid("Nombre Checkbox Cuatro"), .short)
                checkTag4NameField.select()
                return
            }

            // Checkbox Five
            if checkTag5 && checkTag5Name.isEmpty {
                showError(.campoRequerido, .requierdValid("Nombre Checkbox Cinco"), .short)
                checkTag5NameField.select()
                return
            }

            // Checkbox Six
            if checkTag6 && checkTag6Name.isEmpty{
                showError(.campoRequerido, .requierdValid("Nombre Checkbox Seis"), .short)
                checkTag6NameField.select()
                return
            }

            loadingView(show: true)
            
            API.custAPIV1.saveConfigs(
                configStoreProcessing: nil,
                configContactTags: nil,
                configServiceTags: .init(
                    typeOfServiceObject: typeOfServiceObject,
                    idTagName: idTagName,
                    idTagDescr: idTagDescr,
                    idTagPlaceholder: idTagPlaceholder,
                    secondIDTagRequiered: secondIDTagRequiered,
                    secondIDTagName: secondIDTagName,
                    secondIDTagDescr: secondIDTagDescr,
                    secondIDTagPlaceholder: secondIDTagPlaceholder,
                    useBrandModelMode: useBrandModelMode,
                    tag1: tag1,
                    tag1Name: tag1Name,
                    tag1Placeholder: tag1Placeholder,
                    tag2: tag2,
                    tag2Name: tag2Name,
                    tag2Placeholder: tag2Placeholder,
                    tag3: tag3,
                    tag3Name: tag3Name,
                    tag3Placeholder: tag3Placeholder,
                    tag4: tag4,
                    tag4Name: tag4Name,
                    tag4Placeholder: tag4Placeholder,
                    tag5: tag5,
                    tag5Name: tag5Name,
                    tag5Placeholder: tag5Placeholder,
                    tag6: tag6,
                    tag6Name: tag6Name,
                    tag6Placeholder: tag6Placeholder,
                    checkTag1: checkTag1,
                    checkTag1Name: checkTag1Name,
                    checkTag2: checkTag2,
                    checkTag2Name: checkTag2Name,
                    checkTag3: checkTag3,
                    checkTag3Name: checkTag3Name,
                    checkTag4: checkTag4,
                    checkTag4Name: checkTag4Name,
                    checkTag5: checkTag5,
                    checkTag5Name: checkTag5Name,
                    checkTag6: checkTag6,
                    checkTag6Name: checkTag6Name,
                    tagDescrName: tagDescrName,
                    tagDescrPlaceholder: tagDescrPlaceholder,
                    additionalMainTags: additionalMainTags,
                    serviceMap: serviceMap,
                    sideStatus: sideStatus,
                    diagnosticResolutionActions: diagnosticResolutionActions
                ),
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
