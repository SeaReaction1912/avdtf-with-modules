### avdtf-with-modules
Terraform with Modules for basic AVD environment

Change Log:
v1.0 - Fixed initial commit to remove ```module``` block specified in child module ```main.tf```, which was causing duplication of resources.
     - Added rudimentary ```count``` configuration for VM module to support multiple VM creation.
     - multiple other changes as necessary to debug test deployment until successful completion.
