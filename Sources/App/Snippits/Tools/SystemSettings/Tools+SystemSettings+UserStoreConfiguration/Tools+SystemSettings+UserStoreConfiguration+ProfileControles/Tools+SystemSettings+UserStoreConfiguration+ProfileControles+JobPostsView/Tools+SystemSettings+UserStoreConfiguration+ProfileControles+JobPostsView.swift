//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+JobPostsView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {
    
    class JobPostsView: Div {

        override class var name: String { "div" } 
        
        @State var jobPosts: [CustJobPostQuick]

        init(
            jobPosts: [CustJobPostQuick]
        ) {
            self.jobPosts = jobPosts
            super.init()
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        @State var selectedId: UUID? = nil

        lazy var itemsContainer = Div()
            
        @DOM override var body: DOM.Content {

            Div{

                Div {

                    Table().noResult(label: "No hay puestos de trabajo", button: "Agregar")  {
                        self.createJob()
                    }
                    .hidden(self.$jobPosts.map{ !$0.isEmpty })

                    ForEach(self.$jobPosts){ jobPost in
                        Div(jobPost.name).class(.uibtnLarge)
                            .border(width: .medium, style: self.$selectedId.map{ ($0 != jobPost.id) ? .none : .solid }, color: .lightBlue )
                            .width(90.percent)
                            .marginTop(7.px)
                            .onClick {
                                self.loadJob(jobPost)
                            }
                    }
                    .hidden(self.$jobPosts.map{ $0.isEmpty })
                
                }
                .custom("height", "calc(100% - 22px)")
                .class(.roundDarkBlue)
                .padding(all: 7.px)
                .overflow(.auto)
            }
            .height(100.percent)
            .width(30.percent)
            .float(.left)

            Div{
                self.itemsContainer
                .custom("height", "calc(100% - 14px)")
                .padding(all: 7.px)
                .overflow(.auto)
            }
            .height(100.percent)
            .width(70.percent)
            .float(.left)
            
        }

        override func buildUI() {
            super.buildUI()
            
            height(100.percent)
            width(100.percent)
            
        }
    
        func createJob() {

            let view = JobPostView(jobPost: nil, notes: []) { action in
                
                switch action {
                case .create(let job):
                self.jobPosts.append(job)
                case .update(let job):
                
                var jobPosts: [CustJobPostQuick] = []

                self.jobPosts.forEach{ currentJob in 

                    if currentJob.id == job.id {
                        jobPosts.append(job)
                        self.selectedId = job.id
                    }
                    else {
                        jobPosts.append(currentJob)
                    }

                }

                self.jobPosts = jobPosts

                }

            }
            
            itemsContainer.innerHTML = ""

            itemsContainer.appendChild(view)

        }

        func loadJob(_ jobPost: CustJobPostQuick) {

            loadingView(show: true)

            API.custAPIV1.getJobPost(jobId: jobPost.id) { resp in

                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError )
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo payload de data.")
                    return
                }

                self.selectedId = jobPost.id

                let view = JobPostView(jobPost: payload.job, notes: payload.notes) { action in
                    
                    switch action {
                    case .create(let job):
                    self.jobPosts.append(job)
                    case .update(let job):
                    
                    var jobPosts: [CustJobPostQuick] = []

                    self.jobPosts.forEach{ currentJob in 

                        if currentJob.id == job.id {
                            jobPosts.append(job)
                        }
                        else {
                            jobPosts.append(currentJob)
                        }

                    }

                    self.jobPosts = jobPosts

                    }

                }
                
                self.itemsContainer.innerHTML = ""

                self.itemsContainer.appendChild(view)

            }
                
        }
    
    }
}