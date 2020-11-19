require 'rails_helper'

RSpec.describe Procedure, type: :model do
    subject { described_class }

    describe 'self.find_by_name_pattern' do
        before do
            subject.create([
                { name: "Esophageal motility study" },
                { name: "Phage therapy" },
                { name: "Apheresis" },
                { name: "Image-guided surgery" }
            ])
        end
        let(:expected_procedure_list) {
            [
                "Phage therapy",
                "Image-guided surgery",
                "Esophageal motility study"
            ]
        }
        let(:pattern) { "age" }

        it 'returns sorted list of procedures matched with pattern' do
            procedure_names = subject.find_by_name_pattern(pattern).map(&:name)
            expect(procedure_names).to eq(expected_procedure_list)
        end
    end

    describe 'self.collect_data_from_source' do
        context 'for success response' do
            let(:saved_procedure_list) {
                [
                    "Auscultation",
                    "Medical inspection",
                    "Palpation",
                    "Percussion (medicine)",
                    "Vital signs",
                    "Cardiac stress test",
                    "Electrocardiography",
                    "Electrocorticography",
                    "Electroencephalography",
                    "Electromyography",
                    "Electroneuronography",
                    "Electronystagmography",
                    "Electrooculography",
                    "Electroretinography",
                    "Endoluminal capsule monitoring",
                    "Endoscopy",
                    "Esophageal motility study",
                    "Evoked potential",
                    "Magnetoencephalography",
                    "Medical imaging",
                    "Neuroimaging",
                    "Posturography",
                    "Thrombosis prophylaxis",
                    "Precordial thump",
                    "Politzerization",
                    "Hemodialysis",
                    "Hemofiltration",
                    "Plasmapheresis",
                    "Apheresis",
                    "Extracorporeal membrane oxygenation",
                    "Cancer immunotherapy",
                    "Cancer vaccine",
                    "Cervical conization",
                    "Chemotherapy",
                    "Cytoluminescent therapy",
                    "Insulin potentiation therapy",
                    "Low-dose chemotherapy",
                    "Monoclonal antibody therapy",
                    "Photodynamic therapy",
                    "Radiation therapy",
                    "Targeted therapy",
                    "Tracheal intubation",
                    "Unsealed source radiotherapy",
                    "Virtual reality therapy",
                    "Physical therapy/Physiotherapy",
                    "Speech therapy",
                    "Phototerapy",
                    "Hydrotherapy",
                    "Heat therapy",
                    "Shock therapy",
                    "Fluid replacement therapy",
                    "Palliative care",
                    "Hyperbaric oxygen therapy",
                    "Oxygen therapy",
                    "Gene therapy",
                    "Enzyme replacement therapy",
                    "Intravenous therapy",
                    "Phage therapy",
                    "Respiratory therapy",
                    "Vision therapy",
                    "Electrotherapy",
                    "Transcutaneous electrical nerve stimulation",
                    "Laser therapy",
                    "Combination therapy",
                    "Occupational therapy",
                    "Immunization",
                    "Vaccination",
                    "Immunosuppressive therapy",
                    "Psychotherapy",
                    "Drug therapy",
                    "Acupuncture",
                    "Antivenom",
                    "Magnetic therapy",
                    "Craniosacral therapy",
                    "Chelation therapy",
                    "Hormonal therapy",
                    "Hormone replacement therapy",
                    "Opiate replacement therapy",
                    "Cell therapy",
                    "Stem cell treatments",
                    "Intubation",
                    "Nebulization",
                    "Inhalation therapy",
                    "Particle therapy",
                    "Proton therapy",
                    "Fluoride therapy",
                    "Cold compression therapy",
                    "Animal-Assisted Therapy",
                    "Negative Pressure Wound Therapy",
                    "Nicotine replacement therapy",
                    "Oral rehydration therapy",
                    "Ablation",
                    "Amputation",
                    "Biopsy",
                    "Cardiopulmonary resuscitation",
                    "Cryosurgery",
                    "Endoscopic surgery",
                    "Facial rejuvenation",
                    "General surgery",
                    "Hand surgery",
                    "Hemilaminectomy",
                    "Image-guided surgery",
                    "Knee cartilage replacement therapy",
                    "Laminectomy",
                    "Laparoscopic surgery",
                    "Lithotomy",
                    "Lithotriptor",
                    "Lobotomy",
                    "Neovaginoplasty",
                    "Radiosurgery",
                    "Stereotactic surgery",
                    "Radiosurgery",
                    "Vaginoplasty",
                    "Xenotransplantation",
                    "Dissociative anesthesia",
                    "General anesthesia",
                    "Local anesthesia",
                    "Regional anesthesia",
                    "Interventional radiology",
                    "Screening (medicine)"
                ]
            }
            # Here I've used VCR to record real response into cassete
            # and use it later in test cases
            it 'returns list of procedures correctly' do
                VCR.use_cassette("response_200") do
                    result = subject.collect_data_from_source
                    expect(result).to eq(saved_procedure_list)
                end
            end
        end

        context 'for bad response' do
            let(:page_not_found_url) { "https://en.wikipedia.org/404" }

            it 'returns result dataset as nil' do
                VCR.use_cassette("response_404") do
                    result = subject.collect_data_from_source(page_not_found_url)
                    expect(subject).to_not receive(:parse_procedures_from_source)
                    expect(result).to be_nil
                end
            end
        end
    end
end