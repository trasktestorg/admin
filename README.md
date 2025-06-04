

SAFETY

- Fine-grained tokens include repo delete in repo write.
- Classic tokens require granting a user admin permissions to all the repos.
  - `prevent_destroy` doesn't work: https://github.com/integrations/terraform-provider-github/issues/2521 (I also tried)
- `archive_on_destroy` is a good mitigation.
- Still need to be super careful with the state.

SAFETY PLAN

- Don't put repos under terraform, only branch protection rules.
- Still need to be super careful with the state.
- So create the state each time to avoid the risk of deleting things that were added to the state.

How to incrementally add state?


SAFETY PLAN

- Use classic PAT token that doesn't allow repo deletion
- Requires using PAT from a github admin user (trask)
- This alleviates the risk of deleting repos!!!


Note: merge queue configuration isn't supported by the branch protection rules resource, so it needs to be configured manually.

