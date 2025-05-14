In APIM we have basically 5 pipelines
ExportAPI
PDBSearch
Producer-APIM
Producer-Import
Transaction-Import

The repo for APIM is in Xchange project under devops repo
There are 2 parts for the pipeline code manifests and pipeline
Structure is like
devops
Manifests
	Dev
		ExportAPI.yml
PDBSearch.yml
Producer-APIM.yml
Producer-Import.yml
Transaction-Import.yml

	QA
		ExportAPI.yml
PDBSearch.yml
Producer-APIM.yml
Producer-Import.yml
Transaction-Import.yml

	UAT
		ExportAPI.yml
PDBSearch.yml
Producer-APIM.yml
Producer-Import.yml
Transaction-Import.yml

	Prod
		ExportAPI.yml
PDBSearch.yml
Producer-APIM.yml
Producer-Import.yml
Transaction-Import.yml

Pipeline
	ExportAPI
		Build_exportapi_pipeline.yml
		Deploy_exportapi_pipeline.yml

PDBSearch
		Build_ PDBSearch_pipeline.yml
		Deploy_ PDBSearch_pipeline.yml

Producer-APIM
		Build_producer_pipeline.yml
		Deploy_producer_api.yml
Producer-Import
		Build_producer_import_pipeline.yml
		Deploy_producerimport.yml
Transaction-Import
		Build_transaction_import_pipeline.yml
		Deploy_transaction_import.yml


Notes
•	For each source code there is a separate source code repo for ex for Producer-Import we have produce_import repo for Transaction-Import we have transaction_iport repo etc.
•	There are 2 branches dev and int


