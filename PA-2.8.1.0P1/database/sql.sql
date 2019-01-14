--TT2517421
 
Insert into SERVICE (ID, BINDING,CONTRACT, DESCRIPTION, ERROR_CODE_FIELD, ERROR_MESSAGE_FIELD, NAME ,OPERATION, PASSWORD, PROVIDER_TYPE, TIMEOUT, URI ,USERNAME, VALIDATED, ERROR_TRANSLATOR) values ((SELECT MAX(ID)+1 FROM SERVICE),'TIBCOBinding',
 	'http://10.2.5.7:7018/ServiceCatalog/ReferenceData/ReferenceData/GetSCandCMP/v1/ReferenceData_GetSCandCMP_v1.xsd',
 	'Gets all SC and CMP','error','error_msg','GetSCandCMP','Request','','2','',
 	'http://10.2.5.80:7073/ServiceCatalog/Business',
 	'',null,null);
  

Insert into SERVICE (ID, BINDING,CONTRACT, DESCRIPTION, ERROR_CODE_FIELD, ERROR_MESSAGE_FIELD, NAME ,OPERATION, PASSWORD, PROVIDER_TYPE, TIMEOUT, URI ,USERNAME, VALIDATED, ERROR_TRANSLATOR) values ((SELECT MAX(ID)+1 FROM SERVICE),'TIBCOBinding',
	'http://10.2.5.7:7018/ServiceCatalog/Integration/Ratio/EditStagingRacio/v1/Ratio_EditStagingRacio_v1.xsd',
	'Sets Approving Ratio to Edit State','error','error_msg','EditStagingRacio','Request','','2','',
	'http://10.2.5.75:7005/ServiceCatalog/Business'
	,'',null,null);
  

Insert into SERVICE (ID, BINDING,CONTRACT, DESCRIPTION, ERROR_CODE_FIELD, ERROR_MESSAGE_FIELD, NAME ,OPERATION, PASSWORD, PROVIDER_TYPE, TIMEOUT, URI ,USERNAME, VALIDATED, ERROR_TRANSLATOR) values ((SELECT MAX(ID)+1 FROM SERVICE),'TIBCOBinding',
	'http://10.2.5.7:7018/ServiceCatalog/Integration/Ratio/RefreshRacioData/v1/Ratio_RefreshRacioData_v1.xsd',
	'Refreshes Billing Engines','error','error_msg','RefreshRacioData','Request','','2','',
	'http://10.2.5.75:7005/ServiceCatalog/Business',
	'',null,null);
 

INSERT INTO prf_profile (id,name,shell_id,urlnovidades,active) VALUES (
UFE_PROFILE_SEQ.NEXTVAL,
'DSI Aprovadores Racios',
(SELECT id FROM prf_shell WHERE description = 'DSI'), 
'http://intranet.unitel.co.ao/crm/imagens_crm.html',
1);


insert into PRF_PROFILEPRIVILEGE values(
(select id from PROCESSES where name='boRatioManagement'),
(select id from PRF_PROFILE where name='DSI Aprovadores Racios'),
(select id from PRF_ACCESSLEVELTYPE where PRF_ACCESSLEVELTYPE.ACCESSLEVELKEY='W'),
null
);

update processes set javascript_files='apps/boRatioManagement/controller/RatioManagement.js' where name = 'boRatioManagement';

update process_controller set CONTROLLER_NAME = 'UFEProcesses.boRatioManagement.controller.RatioManagement' where PROCESS_ID = (SELECT ID FROM PROCESSES WHERE NAME = 'boRatioManagement');

update PROCESS_VIEW set VIEW_NAME = 'UFEProcesses.boRatioManagement.view.RatioManagement' where PROCESSACTION_ID = (SELECT ID FROM PROCESS_ACTION WHERE PROCESS_ID = (SELECT ID FROM PROCESSES WHERE NAME = 'boRatioManagement'));



UPDATE SERVICE SET CONTRACTCONTENT = NULL WHERE NAME IN ('GetDedicatedAccounts','GetExternalSystems','ManageDedicatedAccounts','ManageExternalSystems','ManageLimits','GetLimits');

 

INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('EAI_-302_-103','pt-PT','BATCH',NULL,'Esta Dedicated Account e Service Class já existem na tabela Live.','boRatioManagement');

insert into service_attribute (id, value, service_id, type_id) values (
(select max(id)+1 from service_attribute),
'RelationList',
(select id from service where name='GetSCandCMP'),
(select id from service_attribute_type where name='list'));

insert into service_service_attribute values (
(select id from service where name='GetSCandCMP'),
(select id from service_attribute where value = 'RelationList' and service_id=(select id from service where name='GetSCandCMP') and type_id=(select id from service_attribute_type where name='list'))
);



 
insert into service_attribute (id, value, service_id, type_id) values (
(select max(id)+1 from service_attribute),
'LimitList',
(select id from service where name='GetDedicatedAccounts'),
(select id from service_attribute_type where name='list'));

insert into service_service_attribute values (
(select id from service where name='GetDedicatedAccounts'),
(select id from service_attribute where value = 'LimitList' and service_id=(select id from service where name='GetDedicatedAccounts') and type_id=(select id from service_attribute_type where name='list'))
);



insert into service_attribute (id, value, service_id, type_id) values (
(select max(id)+1 from service_attribute),
'LimitList',
(select id from service where name='GetExternalSystems'),
(select id from service_attribute_type where name='list'));

insert into service_service_attribute values (
(select id from service where name='GetExternalSystems'),
(select id from service_attribute where value = 'LimitList' and service_id=(select id from service where name='GetExternalSystems') and type_id=(select id from service_attribute_type where name='list'))
);



insert into service_attribute (id, value, service_id, type_id) values (
(select max(id)+1 from service_attribute),
'MessageList',
(select id from service where name='GetDedicatedAccounts'),
(select id from service_attribute_type where name='list'));

insert into service_service_attribute values (
(select id from service where name='GetDedicatedAccounts'),
(select id from service_attribute where value = 'MessageList' and service_id=(select id from service where name='GetDedicatedAccounts') and type_id=(select id from service_attribute_type where name='list'))
);



insert into service_attribute (id, value, service_id, type_id) values (
(select max(id)+1 from service_attribute),
'MessageList',
(select id from service where name='GetExternalSystems'),
(select id from service_attribute_type where name='list'));

insert into service_service_attribute values (
(select id from service where name='GetExternalSystems'),
(select id from service_attribute where value = 'MessageList' and service_id=(select id from service where name='GetExternalSystems') and type_id=(select id from service_attribute_type where name='list'))
);



--Remover os valores repetidos da LOV_DEDICATED_ACCOUNT_UNIT
declare
record_id number;
begin
SELECT REF_DATA_REC_ID into record_id FROM RFD_VALUES WHERE value = 'seg' AND REF_DATA_ITEM_ID IN (Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DEDICATED_ACCOUNT_UNIT') and item_name = 'text');

DELETE FROM RFD_VALUES WHERE REF_DATA_REC_ID = record_id;
DELETE FROM RFD_RECORD WHERE ID = record_id;

SELECT REF_DATA_REC_ID into record_id FROM RFD_VALUES WHERE value = 'Min' AND REF_DATA_ITEM_ID IN (Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DEDICATED_ACCOUNT_UNIT') and item_name = 'text');

DELETE FROM RFD_VALUES WHERE REF_DATA_REC_ID = record_id;
DELETE FROM RFD_RECORD WHERE ID = record_id;
END;


--CRIAÇÃO DA LOV_DA_ACCOUNT_TYPE
INSERT INTO RFD_REFDATA (id, name, refdatatypeid) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'LOV_DA_ACCOUNT_TYPE', (Select id from rfd_type where description='UFE')); 
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'text', (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'value', (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'unit', (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'muda', (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'mudaDisabled', (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE' ));


--DADOS A INSERIR NA LOV_DA_ACCOUNT_TYPE
INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Acumulador',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'ACCUMULATOR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'ACCUMULATOR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='unit'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '1',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='muda'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'true',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='mudaDisabled'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'DA',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'DA',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'UTT',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='unit'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '1',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='muda'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'false',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='mudaDisabled'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PAM',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PAM',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PAM',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='unit'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '1',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='muda'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'true',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_DA_ACCOUNT_TYPE') and item_name='mudaDisabled'));



--CRIAÇÃO DA LOV_ACTION_CODES
INSERT INTO RFD_REFDATA (id, name, refdatatypeid) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'LOV_ACTION_CODES', (Select id from rfd_type where description='UFE')); 
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'text', (Select id from rfd_refdata where name='LOV_ACTION_CODES' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'value', (Select id from rfd_refdata where name='LOV_ACTION_CODES' ));


--DADOS A INSERIR NA LOV_ACTION_CODES
INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_ACTION_CODES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Criação',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_ACTION_CODES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Create',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_ACTION_CODES') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_ACTION_CODES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Edição',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_ACTION_CODES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Update',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_ACTION_CODES') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_ACTION_CODES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Remoção',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_ACTION_CODES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Delete',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_ACTION_CODES') and item_name='value'));



--CRIAÇÃO DA LOV_APPROVAL_STATUS
INSERT INTO RFD_REFDATA (id, name, refdatatypeid) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'LOV_APPROVAL_STATUS', (Select id from rfd_type where description='UFE')); 
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'text', (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'value', (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS' ));


--DADOS A INSERIR NA LOV_APPROVAL_STATUS
INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Pendente de Aprovação',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PendingApproval',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Aprovado',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Approved',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Rejeitado',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Rejected',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Em Edição',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Edit',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Cancelado',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Cancelled',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_APPROVAL_STATUS') and item_name='value'));




--CRIAÇÃO DA LOV_LIMITS_OPERATIONS
INSERT INTO RFD_REFDATA (id, name, refdatatypeid) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'LOV_LIMITS_OPERATIONS', (Select id from rfd_type where description='UFE')); 
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'text', (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'value', (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS' ));


--DADOS A INSERIR NA LOV_LIMITS_OPERATIONS
INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'CAJ',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'CAJ',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'DTR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'DTR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'TRB',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'TRB',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RMPC',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RMPC',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PNAR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PNAR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'APDIR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'APDIR',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RPSS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RPSS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'BCMS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'BCMS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'SET',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'SET',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'DAJ',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'DAJ',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'APSS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'APSS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'TRA',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'TRA',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RMPD',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RMPD',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PNA',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'PNA',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'APDI',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'APDI',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RPDI',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RPDI',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RNPSS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RNPSS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RND',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'RND',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_LIMITS_OPERATIONS') and item_name='value'));



--CRIAÇÃO DA LOV_MUDA_VALUES
INSERT INTO RFD_REFDATA (id, name, refdatatypeid) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'LOV_MUDA_VALUES', (Select id from rfd_type where description='UFE')); 
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'text', (Select id from rfd_refdata where name='LOV_MUDA_VALUES' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'value', (Select id from rfd_refdata where name='LOV_MUDA_VALUES' ));
INSERT INTO RFD_REFDATA_ITEMS (id, ITEM_NAME, REF_DATA_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, 'unit', (Select id from rfd_refdata where name='LOV_MUDA_VALUES' ));


--DADOS A INSERIR NA LOV_MUDA_VALUES
INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_MUDA_VALUES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'Default',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '1',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'UTT',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='unit'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_MUDA_VALUES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'UTT',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '1',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'UTT',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='unit'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_MUDA_VALUES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'SEGUNDO',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '0',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'SEG',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='unit'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_MUDA_VALUES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'SMS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '5',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'SMS',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='unit'));

INSERT INTO RFD_RECORD (id, REF_DATA_ID, PARENT, DISPLAY_ORDER, ACTIVE, LANGUAGE, IS_DEFAULT) VALUES (UFE_REFDATA_RECORD_SEQ.NEXTVAL, (Select id from rfd_refdata where name='LOV_MUDA_VALUES'), null, null, 1, 'PT', 0);
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'MB',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='text'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, '6',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='value'));
INSERT INTO RFD_VALUES (id, REF_DATA_REC_ID, value, REF_DATA_ITEM_ID) VALUES (UFE_REFDATA_SEQ.NEXTVAL, UFE_REFDATA_RECORD_SEQ.currval, 'MB',(Select id from rfd_refdata_items where ref_data_id in (Select id from rfd_refdata where name='LOV_MUDA_VALUES') and item_name='unit'));
 
--Fields
--canApproveDedicatedAccounts
INSERT INTO PRF_FIELD VALUES(
(SELECT max(id)+1 FROM PRF_FIELD),
'canApproveDedicatedAccounts',
(SELECT id FROM PROCESSES WHERE name='boRatioManagement'),
'Aprovar Dedicated Accounts',
'Aprovar Dedicated Accounts',
null,
0
);

insert into PRF_FIELDPROFILEPRIVILEGE
select
1,
(select id from PRF_FIELD where name='canApproveDedicatedAccounts' and processid=(select id from PROCESSES where name='boRatioManagement')),
prf_profile.id,
(select id from PRF_ACCESSLEVELTYPE where ACCESSLEVELKEY='W'),
(select id from PRF_FIELD where name='canApproveDedicatedAccounts' and processid=(select id from PROCESSES where name='boRatioManagement')),
prf_profile.id from prf_profile where name = 'DSI Aprovadores Racios';



--canApproveExternalSystems
INSERT INTO PRF_FIELD VALUES(
(SELECT max(id)+1 FROM PRF_FIELD),
'canApproveExternalSystems',
(SELECT id FROM PROCESSES WHERE name='boRatioManagement'),
'Aprovar Sistemas Externos',
'Aprovar Sistemas Externos',
null,
0
);

insert into PRF_FIELDPROFILEPRIVILEGE
select
1,
(select id from PRF_FIELD where name='canApproveExternalSystems' and processid=(select id from PROCESSES where name='boRatioManagement')),
prf_profile.id,
(select id from PRF_ACCESSLEVELTYPE where ACCESSLEVELKEY='W'),
(select id from PRF_FIELD where name='canApproveExternalSystems' and processid=(select id from PROCESSES where name='boRatioManagement')),
prf_profile.id from prf_profile where name = 'DSI Aprovadores Racios';




INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('ERROR_DATE_BIG_BEGINNNING','pt-PT','BATCH',NULL,'A data de início não pode ser maior que a data de fim.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('ERROR_MIN_VALUE_BIG','pt-PT','BATCH',NULL,'O valor mínimo não pode ser superior ao valor máximo.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('ITEM_ALREADY_EDIT','pt-PT','BATCH',NULL,'Este item já está a ser editado.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('BILLING_ENGINES_SUCCESS','pt-PT','BATCH',NULL,'Atualização dos rácios nos motores Billing com sucesso.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('ITEM_APPROVED_SUCCESS','pt-PT','BATCH',NULL,'Item aprovado com sucesso.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('ITEM_REJECTED_SUCCESS','pt-PT','BATCH',NULL,'Item rejeitado com sucesso.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('EAI_-403_-403','pt-PT','BATCH',NULL,'Erro interno do sistema externo.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('EAI_-100_-100','pt-PT','BATCH',NULL,'Erro a contactar o sistema externo.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('UFE-023','pt-PT','BATCH',NULL,'Tem que inserir no mínimo {0}.','boRatioManagement');
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('ROLLBACK_SUCCESS','pt-PT','BATCH',NULL,'{0} foi submetida com os valores anteriores com sucesso','boRatioManagement');

INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('EAI_-100_-101','pt-PT','BATCH',NULL,'O registo a remover já não existe. O pedido de aprovação deverá ser rejeitado com esta nota.','boRatioManagement');
 
update PROCESS_MESSAGES set MESSAGE =  'A criação do {0} foi submetida para aprovação com sucesso.' WHERE PROCESSNAME ='boRatioManagement' AND CODE = 'CREATION_SUCCESS';
update PROCESS_MESSAGES set MESSAGE =  'A criação da {0} foi submetida para aprovação com sucesso.' WHERE PROCESSNAME ='boRatioManagement' AND CODE = 'CREATION_SUCCESS_2';
update PROCESS_MESSAGES set MESSAGE =  'A remoção do {0} foi submetida para aprovação com sucesso.' WHERE PROCESSNAME ='boRatioManagement' AND CODE = 'DELETION_SUCCESS';
update PROCESS_MESSAGES set MESSAGE =  'A remoção da {0} foi submetida para aprovação com sucesso.' WHERE PROCESSNAME ='boRatioManagement' AND CODE = 'DELETION_SUCCESS_2';
update PROCESS_MESSAGES set MESSAGE =  'A edição do {0} foi submetida para aprovação com sucesso.' WHERE PROCESSNAME ='boRatioManagement' AND CODE = 'EDITION_SUCCESS';
update PROCESS_MESSAGES set MESSAGE =  'A edição da {0} foi submetida para aprovação com sucesso.' WHERE PROCESSNAME ='boRatioManagement' AND CODE = 'EDITION_SUCCESS_2';
 

update PROCESS_MESSAGES set MESSAGE='Atualização dos rácios de EAI com sucesso.' where MESSAGE like '%ualização dos rácios nos motores Billing com suces%';

update PROCESS_MESSAGES set MESSAGE='Pedido de atualização dos racios de EAI efetuado com sucesso.' where MESSAGE like 'Atualização dos rácios de EAI com sucesso.';
 
INSERT INTO PROCESS_MESSAGES (CODE, LANGUAGE, CREATEDBY, CREATEDON, MESSAGE, PROCESSNAME)
 VALUES ('BILLING_ENGINES_LASTHOUR','pt-PT','BATCH',NULL,'Deverá aguardar {0} minutos antes de realizar novo pedido de atualização de racios de EAI.','boRatioManagement');
