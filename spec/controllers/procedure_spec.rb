require 'rails_helper'

RSpec.describe Api::ProceduresController, type: :controller do
    let(:parsed_response) { JSON.parse(response.body) }
    let(:result_names) { parsed_response.map { |hash| hash["name"] } }

    before do
        Procedure.create([
            { id: 1, name: "Esophageal motility study" },
            { id: 2, name: "Phage therapy" },
            { id: 3, name: "Apheresis" },
            { id: 4, name: "Image-guided surgery" }
        ])
    end

    describe "GET search" do
        subject { get :search, params: params }

        context 'for empty params' do
            let(:params) { { name: "" } }

            it "renders empty json response" do
                subject
                expect(parsed_response).to be_empty
                expect(response.status).to eq(200)
            end
        end

        context 'for non empty params' do
            let(:params) { { name: "age" } }
            let(:expected_procedure_names) {[
                "Phage therapy",
                "Image-guided surgery",
                "Esophageal motility study"
            ]}

            it "renders json response with expected data" do
                subject
                expect(result_names).to eq(expected_procedure_names)
                expect(response.status).to eq(200)
            end
        end
    end

    describe "POST create" do
        subject { post :create }

        context 'for empty list of procedures' do
            it "renders with status 'bad request'" do
                allow(Procedure).to receive(:collect_data_from_source)
                subject
                expect(response.status).to eq(400)
            end
        end

        context 'for non empty list of procedures' do
            let(:imported_data) {[
                "Image-guided surgery",
                "Phage therapy",
                "Esophageal motility study"
            ]}
            let(:data) { Procedure.all }

            before {
                allow(Procedure).to receive(:collect_data_from_source) { imported_data }
            }

            it "renders json response with expected data" do
                allow_any_instance_of(Api::ProceduresController).to receive(:prepare_data) { data }
                allow(Procedure).to receive(:insert_all).with(data) { an_instance_of(ActiveRecord::Result) }
                subject
                expect(response.status).to eq(200)
                expect(parsed_response).to eq(imported_data)
                expect{ Procedure.insert_all(data) }.not_to raise_error
            end

            context 'when raises an error during mass insert' do
                let(:data) { Procedure.last }
                let(:errors) { ["error explanation"] }

                it "renders with status 'unprocessable_entity' " do
                    allow_any_instance_of(Api::ProceduresController).to receive(:prepare_data) { data }
                    allow_any_instance_of(ActiveRecord::RecordInvalid).to receive(:record) { double(errors: errors) }
                    allow(Procedure).to receive(:insert_all).and_raise(ActiveRecord::RecordInvalid)
                    subject
                    expect(response.status).to eq(422)
                    expect(parsed_response).to eq(errors)
                end
            end
        end

        describe "DataFormatter concern" do
            subject { described_class.new.prepare_data(procedure_names) }
            let(:procedure_names) {[
                "Phage therapy",
                "Image-guided surgery",
                "Esophageal motility study"
            ]}

            it "combines array of names with timestamps to build a hash for mass insert" do
                expect(subject.map{|hash| hash[:name]}).to eq(procedure_names)
                expect(subject[0].keys).to eq([:name, :created_at, :updated_at])
            end 
        end
    end
end