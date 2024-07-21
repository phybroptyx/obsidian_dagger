# Cyber Defense eXercise (CDX) Exercise Deployer - OBSIDIAN DAGGER
## main.yml Playbook

```mermaid
---
title: Operation: OBSIDIAN DAGGER Deployment Playbook Flow
---
%%{ init: { "flowchart": { "curve": "bumpX" } } }%%
flowchart LR
	%% Start of the playbook 'obsidian_dagger/main.yml'
	playbook_e7f329b2("obsidian_dagger/main.yml")
		%% Start of the play 'Play: Deploy OBSIDIAN DAGGER VSphere Folder and Networking Environment (1)'
		play_57349dd2["Play: Deploy OBSIDIAN DAGGER VSphere Folder and Networking Environment (1)"]
		style play_57349dd2 fill:#7f4d5f,color:#ffffff
		playbook_e7f329b2 --> |"1"| play_57349dd2
		linkStyle 0 stroke:#7f4d5f,color:#7f4d5f
			pre_task_657dcc37["[pre_task]  include_vars"]
			style pre_task_657dcc37 stroke:#7f4d5f,fill:#ffffff
			play_57349dd2 --> |"1"| pre_task_657dcc37
			linkStyle 1 stroke:#7f4d5f,color:#7f4d5f
			pre_task_f90ccd80["[pre_task]  include_vars"]
			style pre_task_f90ccd80 stroke:#7f4d5f,fill:#ffffff
			play_57349dd2 --> |"2"| pre_task_f90ccd80
			linkStyle 2 stroke:#7f4d5f,color:#7f4d5f
			pre_task_eb9cf5d8["[pre_task]  include_vars"]
			style pre_task_eb9cf5d8 stroke:#7f4d5f,fill:#ffffff
			play_57349dd2 --> |"3"| pre_task_eb9cf5d8
			linkStyle 3 stroke:#7f4d5f,color:#7f4d5f
			%% Start of the role 'vsphere_init'
			play_57349dd2 --> |"4"| role_95141b26
			linkStyle 4 stroke:#7f4d5f,color:#7f4d5f
			role_95141b26("[role] vsphere_init")
			style role_95141b26 fill:#7f4d5f,color:#ffffff,stroke:#7f4d5f
				task_acaac5d2[" vsphere_init : Initialize Terraform Environment"]
				style task_acaac5d2 stroke:#7f4d5f,fill:#ffffff
				role_95141b26 --> |"1"| task_acaac5d2
				linkStyle 5 stroke:#7f4d5f,color:#7f4d5f
				task_8e9948ed[" vsphere_init : {{ task_title }}"]
				style task_8e9948ed stroke:#7f4d5f,fill:#ffffff
				role_95141b26 --> |"2"| task_8e9948ed
				linkStyle 6 stroke:#7f4d5f,color:#7f4d5f
			%% End of the role 'vsphere_init'
		%% End of the play 'Play: Deploy OBSIDIAN DAGGER VSphere Folder and Networking Environment (1)'
		%% Start of the play 'Play: Deploy Blue/Red Team Service Delivery Point Routers (1)'
		play_ff446496["Play: Deploy Blue/Red Team Service Delivery Point Routers (1)"]
		style play_ff446496 fill:#10bc18,color:#ffffff
		playbook_e7f329b2 --> |"2"| play_ff446496
		linkStyle 7 stroke:#10bc18,color:#10bc18
			pre_task_5df0ccd7["[pre_task]  include_vars"]
			style pre_task_5df0ccd7 stroke:#10bc18,fill:#ffffff
			play_ff446496 --> |"1"| pre_task_5df0ccd7
			linkStyle 8 stroke:#10bc18,color:#10bc18
			pre_task_ae7ea805["[pre_task]  include_vars"]
			style pre_task_ae7ea805 stroke:#10bc18,fill:#ffffff
			play_ff446496 --> |"2"| pre_task_ae7ea805
			linkStyle 9 stroke:#10bc18,color:#10bc18
			pre_task_daf5c422["[pre_task]  include_vars"]
			style pre_task_daf5c422 stroke:#10bc18,fill:#ffffff
			play_ff446496 --> |"3"| pre_task_daf5c422
			linkStyle 10 stroke:#10bc18,color:#10bc18
			%% Start of the role 'sdp_deploy'
			play_ff446496 --> |"4"| role_63a0dce5
			linkStyle 11 stroke:#10bc18,color:#10bc18
			role_63a0dce5("[role] sdp_deploy")
			style role_63a0dce5 fill:#10bc18,color:#ffffff,stroke:#10bc18
				task_9fb19f3a[" sdp_deploy : Initialize Terraform Environment"]
				style task_9fb19f3a stroke:#10bc18,fill:#ffffff
				role_63a0dce5 --> |"1"| task_9fb19f3a
				linkStyle 12 stroke:#10bc18,color:#10bc18
				task_c31cc4c1[" sdp_deploy : {{ task_title }}"]
				style task_c31cc4c1 stroke:#10bc18,fill:#ffffff
				role_63a0dce5 --> |"2"| task_c31cc4c1
				linkStyle 13 stroke:#10bc18,color:#10bc18
			%% End of the role 'sdp_deploy'
			%% Start of the role 'sdp_configure'
			play_ff446496 --> |"5"| role_f8bc4139
			linkStyle 14 stroke:#10bc18,color:#10bc18
			role_f8bc4139("[role] sdp_configure")
			style role_f8bc4139 fill:#10bc18,color:#ffffff,stroke:#10bc18
				task_37b5a2d1[" sdp_configure : Waiting for SDP Routers to be available..."]
				style task_37b5a2d1 stroke:#10bc18,fill:#ffffff
				role_f8bc4139 --> |"1"| task_37b5a2d1
				linkStyle 15 stroke:#10bc18,color:#10bc18
				task_c0637f03[" sdp_configure : {{ task_title }}"]
				style task_c0637f03 stroke:#10bc18,fill:#ffffff
				role_f8bc4139 --> |"2"| task_c0637f03
				linkStyle 16 stroke:#10bc18,color:#10bc18
				task_0bc9e656[" sdp_configure : {{ task_title }}"]
				style task_0bc9e656 stroke:#10bc18,fill:#ffffff
				role_f8bc4139 --> |"3"| task_0bc9e656
				linkStyle 17 stroke:#10bc18,color:#10bc18
			%% End of the role 'sdp_configure'
		%% End of the play 'Play: Deploy Blue/Red Team Service Delivery Point Routers (1)'
		%% Start of the play 'Play: Deploy Blue Team Mission Partner Domain Controllers (1)'
		play_1a4b6c0c["Play: Deploy Blue Team Mission Partner Domain Controllers (1)"]
		style play_1a4b6c0c fill:#995733,color:#ffffff
		playbook_e7f329b2 --> |"3"| play_1a4b6c0c
		linkStyle 18 stroke:#995733,color:#995733
			pre_task_78862d80["[pre_task]  include_vars"]
			style pre_task_78862d80 stroke:#995733,fill:#ffffff
			play_1a4b6c0c --> |"1"| pre_task_78862d80
			linkStyle 19 stroke:#995733,color:#995733
			pre_task_e29a0a0d["[pre_task]  include_vars"]
			style pre_task_e29a0a0d stroke:#995733,fill:#ffffff
			play_1a4b6c0c --> |"2"| pre_task_e29a0a0d
			linkStyle 20 stroke:#995733,color:#995733
			pre_task_64126cde["[pre_task]  include_vars"]
			style pre_task_64126cde stroke:#995733,fill:#ffffff
			play_1a4b6c0c --> |"3"| pre_task_64126cde
			linkStyle 21 stroke:#995733,color:#995733
			%% Start of the role 'dc_deploy'
			play_1a4b6c0c --> |"4"| role_34de0866
			linkStyle 22 stroke:#995733,color:#995733
			role_34de0866("[role] dc_deploy")
			style role_34de0866 fill:#995733,color:#ffffff,stroke:#995733
				task_d510b0bf[" dc_deploy : Initialize Terraform Environment"]
				style task_d510b0bf stroke:#995733,fill:#ffffff
				role_34de0866 --> |"1"| task_d510b0bf
				linkStyle 23 stroke:#995733,color:#995733
				task_5700ad9c[" dc_deploy : {{ task_title }}"]
				style task_5700ad9c stroke:#995733,fill:#ffffff
				role_34de0866 --> |"2"| task_5700ad9c
				linkStyle 24 stroke:#995733,color:#995733
			%% End of the role 'dc_deploy'
			%% Start of the role 'dc_configure'
			play_1a4b6c0c --> |"5"| role_e33ae347
			linkStyle 25 stroke:#995733,color:#995733
			role_e33ae347("[role] dc_configure")
			style role_e33ae347 fill:#995733,color:#ffffff,stroke:#995733
				task_d8b22e37[" dc_configure : Waiting for stk-dc-01 to be available..."]
				style task_d8b22e37 stroke:#995733,fill:#ffffff
				role_e33ae347 --> |"1"| task_d8b22e37
				linkStyle 26 stroke:#995733,color:#995733
				task_0839eabe[" dc_configure : {{ task_title }}"]
				style task_0839eabe stroke:#995733,fill:#ffffff
				role_e33ae347 --> |"2"| task_0839eabe
				linkStyle 27 stroke:#995733,color:#995733
				task_99a7cfd7[" dc_configure : Waiting for {{ vm }} to restart (Timeout: 5 min)..."]
				style task_99a7cfd7 stroke:#995733,fill:#ffffff
				role_e33ae347 --> |"3"| task_99a7cfd7
				linkStyle 28 stroke:#995733,color:#995733
				task_fb978ead[" dc_configure : Waiting for {{ vm }} reboot to complete  (Timeout: 5 min)..."]
				style task_fb978ead stroke:#995733,fill:#ffffff
				role_e33ae347 --> |"4"| task_fb978ead
				linkStyle 29 stroke:#995733,color:#995733
			%% End of the role 'dc_configure'
			%% Start of the role 'ad_deploy'
			play_1a4b6c0c --> |"6"| role_8e2a7e37
			linkStyle 30 stroke:#995733,color:#995733
			role_8e2a7e37("[role] ad_deploy")
			style role_8e2a7e37 fill:#995733,color:#ffffff,stroke:#995733
				task_b55f1263[" ad_deploy : Waiting for stk-dc-01 to be available..."]
				style task_b55f1263 stroke:#995733,fill:#ffffff
				role_8e2a7e37 --> |"1"| task_b55f1263
				linkStyle 31 stroke:#995733,color:#995733
				task_884c67de[" ad_deploy : {{ task_title }}"]
				style task_884c67de stroke:#995733,fill:#ffffff
				role_8e2a7e37 --> |"2"| task_884c67de
				linkStyle 32 stroke:#995733,color:#995733
			%% End of the role 'ad_deploy'
			%% Start of the role 'dns_configure'
			play_1a4b6c0c --> |"7"| role_0c29f20b
			linkStyle 33 stroke:#995733,color:#995733
			role_0c29f20b("[role] dns_configure")
			style role_0c29f20b fill:#995733,color:#ffffff,stroke:#995733
				task_535ac5bb[" dns_configure : Waiting for stk-dc-01 to be available..."]
				style task_535ac5bb stroke:#995733,fill:#ffffff
				role_0c29f20b --> |"1"| task_535ac5bb
				linkStyle 34 stroke:#995733,color:#995733
				task_309c787d[" dns_configure : {{ task_title }}"]
				style task_309c787d stroke:#995733,fill:#ffffff
				role_0c29f20b --> |"2"| task_309c787d
				linkStyle 35 stroke:#995733,color:#995733
			%% End of the role 'dns_configure'
			%% Start of the role 'ad_configure'
			play_1a4b6c0c --> |"8"| role_c793608e
			linkStyle 36 stroke:#995733,color:#995733
			role_c793608e("[role] ad_configure")
			style role_c793608e fill:#995733,color:#ffffff,stroke:#995733
				task_a1f2e5f7[" ad_configure : Waiting for stk-dc-01 to be available..."]
				style task_a1f2e5f7 stroke:#995733,fill:#ffffff
				role_c793608e --> |"1"| task_a1f2e5f7
				linkStyle 37 stroke:#995733,color:#995733
				task_507fe827[" ad_configure : {{ task_title }}"]
				style task_507fe827 stroke:#995733,fill:#ffffff
				role_c793608e --> |"2"| task_507fe827
				linkStyle 38 stroke:#995733,color:#995733
				task_ac9c71ed[" ad_configure : {{ task_title }}"]
				style task_ac9c71ed stroke:#995733,fill:#ffffff
				role_c793608e --> |"3"| task_ac9c71ed
				linkStyle 39 stroke:#995733,color:#995733
				task_bd4c7873[" ad_configure : {{ task_title }}"]
				style task_bd4c7873 stroke:#995733,fill:#ffffff
				role_c793608e --> |"4"| task_bd4c7873
				linkStyle 40 stroke:#995733,color:#995733
				task_e48cff67[" ad_configure : {{ task_title }}"]
				style task_e48cff67 stroke:#995733,fill:#ffffff
				role_c793608e --> |"5"| task_e48cff67
				linkStyle 41 stroke:#995733,color:#995733
			%% End of the role 'ad_configure'
			%% Start of the role 'dhcp_configure'
			play_1a4b6c0c --> |"9"| role_1bf621f2
			linkStyle 42 stroke:#995733,color:#995733
			role_1bf621f2("[role] dhcp_configure")
			style role_1bf621f2 fill:#995733,color:#ffffff,stroke:#995733
				task_8f0b2603[" dhcp_configure : Waiting for stk-dc-01 to be available..."]
				style task_8f0b2603 stroke:#995733,fill:#ffffff
				role_1bf621f2 --> |"1"| task_8f0b2603
				linkStyle 43 stroke:#995733,color:#995733
				task_a5717878[" dhcp_configure : {{ task_title }}"]
				style task_a5717878 stroke:#995733,fill:#ffffff
				role_1bf621f2 --> |"2"| task_a5717878
				linkStyle 44 stroke:#995733,color:#995733
			%% End of the role 'dhcp_configure'
		%% End of the play 'Play: Deploy Blue Team Mission Partner Domain Controllers (1)'
		%% Start of the play 'Play: Deploy Blue Team Mission Partner Member Servers (1)'
		play_a767cc56["Play: Deploy Blue Team Mission Partner Member Servers (1)"]
		style play_a767cc56 fill:#454687,color:#ffffff
		playbook_e7f329b2 --> |"4"| play_a767cc56
		linkStyle 45 stroke:#454687,color:#454687
			pre_task_ebb34e30["[pre_task]  include_vars"]
			style pre_task_ebb34e30 stroke:#454687,fill:#ffffff
			play_a767cc56 --> |"1"| pre_task_ebb34e30
			linkStyle 46 stroke:#454687,color:#454687
			pre_task_7cfe72da["[pre_task]  include_vars"]
			style pre_task_7cfe72da stroke:#454687,fill:#ffffff
			play_a767cc56 --> |"2"| pre_task_7cfe72da
			linkStyle 47 stroke:#454687,color:#454687
			pre_task_ff09d3b0["[pre_task]  include_vars"]
			style pre_task_ff09d3b0 stroke:#454687,fill:#ffffff
			play_a767cc56 --> |"3"| pre_task_ff09d3b0
			linkStyle 48 stroke:#454687,color:#454687
			%% Start of the role 'mbr_server_deploy'
			play_a767cc56 --> |"4"| role_d122aa28
			linkStyle 49 stroke:#454687,color:#454687
			role_d122aa28("[role] mbr_server_deploy")
			style role_d122aa28 fill:#454687,color:#ffffff,stroke:#454687
				task_1fb17f05[" mbr_server_deploy : Initialize Terraform Environment"]
				style task_1fb17f05 stroke:#454687,fill:#ffffff
				role_d122aa28 --> |"1"| task_1fb17f05
				linkStyle 50 stroke:#454687,color:#454687
				task_273a7fea[" mbr_server_deploy : {{ task_title }}"]
				style task_273a7fea stroke:#454687,fill:#ffffff
				role_d122aa28 --> |"2"| task_273a7fea
				linkStyle 51 stroke:#454687,color:#454687
			%% End of the role 'mbr_server_deploy'
		%% End of the play 'Play: Deploy Blue Team Mission Partner Member Servers (1)'
		%% Start of the play 'Play: Deploy Blue Team Mission Partner Client Workstations (1)'
		play_bfd431f0["Play: Deploy Blue Team Mission Partner Client Workstations (1)"]
		style play_bfd431f0 fill:#8bb616,color:#ffffff
		playbook_e7f329b2 --> |"5"| play_bfd431f0
		linkStyle 52 stroke:#8bb616,color:#8bb616
			pre_task_1270fdf4["[pre_task]  include_vars"]
			style pre_task_1270fdf4 stroke:#8bb616,fill:#ffffff
			play_bfd431f0 --> |"1"| pre_task_1270fdf4
			linkStyle 53 stroke:#8bb616,color:#8bb616
			pre_task_e064e6ae["[pre_task]  include_vars"]
			style pre_task_e064e6ae stroke:#8bb616,fill:#ffffff
			play_bfd431f0 --> |"2"| pre_task_e064e6ae
			linkStyle 54 stroke:#8bb616,color:#8bb616
			pre_task_83b55b55["[pre_task]  include_vars"]
			style pre_task_83b55b55 stroke:#8bb616,fill:#ffffff
			play_bfd431f0 --> |"3"| pre_task_83b55b55
			linkStyle 55 stroke:#8bb616,color:#8bb616
			%% Start of the role 'dev_deploy'
			play_bfd431f0 --> |"4"| role_4067e06b
			linkStyle 56 stroke:#8bb616,color:#8bb616
			role_4067e06b("[role] dev_deploy")
			style role_4067e06b fill:#8bb616,color:#ffffff,stroke:#8bb616
				task_15627688[" dev_deploy : Initialize Terraform Environment"]
				style task_15627688 stroke:#8bb616,fill:#ffffff
				role_4067e06b --> |"1"| task_15627688
				linkStyle 57 stroke:#8bb616,color:#8bb616
				task_1d6cfdf6[" dev_deploy : {{ task_title }}"]
				style task_1d6cfdf6 stroke:#8bb616,fill:#ffffff
				role_4067e06b --> |"2"| task_1d6cfdf6
				linkStyle 58 stroke:#8bb616,color:#8bb616
			%% End of the role 'dev_deploy'
			%% Start of the role 'hr_deploy'
			play_bfd431f0 --> |"5"| role_2f460bd0
			linkStyle 59 stroke:#8bb616,color:#8bb616
			role_2f460bd0("[role] hr_deploy")
			style role_2f460bd0 fill:#8bb616,color:#ffffff,stroke:#8bb616
				task_9df966b4[" hr_deploy : Initialize Terraform Environment"]
				style task_9df966b4 stroke:#8bb616,fill:#ffffff
				role_2f460bd0 --> |"1"| task_9df966b4
				linkStyle 60 stroke:#8bb616,color:#8bb616
				task_9ba4fc93[" hr_deploy : {{ task_title }}"]
				style task_9ba4fc93 stroke:#8bb616,fill:#ffffff
				role_2f460bd0 --> |"2"| task_9ba4fc93
				linkStyle 61 stroke:#8bb616,color:#8bb616
			%% End of the role 'hr_deploy'
			%% Start of the role 'rsrch_deploy'
			play_bfd431f0 --> |"6"| role_eacbcbea
			linkStyle 62 stroke:#8bb616,color:#8bb616
			role_eacbcbea("[role] rsrch_deploy")
			style role_eacbcbea fill:#8bb616,color:#ffffff,stroke:#8bb616
				task_84da1060[" rsrch_deploy : Initialize Terraform Environment"]
				style task_84da1060 stroke:#8bb616,fill:#ffffff
				role_eacbcbea --> |"1"| task_84da1060
				linkStyle 63 stroke:#8bb616,color:#8bb616
				task_76b3457f[" rsrch_deploy : {{ task_title }}"]
				style task_76b3457f stroke:#8bb616,fill:#ffffff
				role_eacbcbea --> |"2"| task_76b3457f
				linkStyle 64 stroke:#8bb616,color:#8bb616
			%% End of the role 'rsrch_deploy'
			%% Start of the role 'ops_deploy'
			play_bfd431f0 --> |"7"| role_8aad7afb
			linkStyle 65 stroke:#8bb616,color:#8bb616
			role_8aad7afb("[role] ops_deploy")
			style role_8aad7afb fill:#8bb616,color:#ffffff,stroke:#8bb616
				task_5c60688d[" ops_deploy : Initialize Terraform Environment"]
				style task_5c60688d stroke:#8bb616,fill:#ffffff
				role_8aad7afb --> |"1"| task_5c60688d
				linkStyle 66 stroke:#8bb616,color:#8bb616
				task_79a63b8d[" ops_deploy : {{ task_title }}"]
				style task_79a63b8d stroke:#8bb616,fill:#ffffff
				role_8aad7afb --> |"2"| task_79a63b8d
				linkStyle 67 stroke:#8bb616,color:#8bb616
			%% End of the role 'ops_deploy'
		%% End of the play 'Play: Deploy Blue Team Mission Partner Client Workstations (1)'
	%% End of the playbook 'obsidian_dagger/main.yml'


```