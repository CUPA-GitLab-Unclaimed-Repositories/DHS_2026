/*
output tables created by SessionItemMarks Job in ISPWarehouse_Research

1. SessAssCmpItemMarks_S&SessionID
2. SessAggCandCmpItemMarkIDs_S&SessionID
3. SessAggQPIGIDs_S&SessionID (this is only tables used as an input in the ILD job)
-----------------------------------------------------------------------

input tables used by ILD job 

1. db_ca.AwardScheduleEvents
2. db_ca.CandidateAssessmentEntries
3. db_ca.CandidateComponentMarkSet
4. db_ca.QuestionPaperItemGroups
5. db_ca.vAggCandCMS
6. db_qp.AssessmentComponents
7. db_qp.AssessmentVersions
8. db_qp.ItemTags
9. db_qp.MarkSchemeItemTags
10. db_qp.MarkSchemes
11. db_qp.MarkingClusters
12. db_qp.OptionComponents
13. db_r.&ReportTriggerLog
14. db_r.SessAggQPIGIDs_S&&SessionID&i
15. db_s.SessionAssessmentComponents
16. db_s.Sessions
17. ild.&FacilitiesByQuartile
18. ild.&ItemFreq
19. ild.&ItemStats
20. ild.&QuartileSummary
21. ild.&ReportLastRun
22. ild.&TestFreq
23. ild.&TestSummary
----------------------------------------------------------------------
*/

%let SessionID=19822; *CI June 25 session;

/*set CIE specific tables*/
%let lib_ILD = ISPWarehouse_CIE_ILD_v001;
%let ReportTriggerLog = ILD_CIEReportTrigger_Log;
%let FacilitiesByQuartile = CIE_FacilitiesByQuartileCountry;
%let ItemFreq = CIE_ItemFreqBySexCountry;
%let ItemStats = CIE_ItemStatsByCountry;
%let QuartileSummary = CIE_CountryQuartileSummary;
%let ReportLastRun = CIE_ReportLastRun;
%let TestFreq = CIE_TestFreqByCountry;
%let TestSummary = CIE_TestSummary;


LIBNAME db_ca meta library = "ISPWarehouse_CandidateAssessment";
LIBNAME db_qp meta library = "ISPWarehouse_QuestionPapers";
LIBNAME db_r meta library="ISPWarehouse_Research"; 
LIBNAME db_s meta library = "ISPWarehouse_Session";
LIBNAME ild meta library = "&lib_ILD";
proc sql;
  create table ild_schema as
  select 
    libname as table_schema,
    memname as table_name,
    name as column_name,
    type as data_type,
    length,
    format,
    label
  from dictionary.columns
/*  *libname must be in upper case. Use exact case of memname as appears in sas;*/
  where libname in ("DB_CA", "DB_QP","DB_R", "DB_S", "ILD") 
  and memname in ("AwardScheduleEvents", "CandidateAssessmentEntries", "CandidateComponentMarkSet", "QuestionPaperItemGroups", "vAggCandCMS",
                  "AssessmentComponents", "AssessmentVersions", "ItemTags", "MarkSchemeItemTags", "MarkSchemes", "MarkingClusters", "OptionComponents",
                  "%upcase(&ReportTriggerLog)", "SessAggQPIGIDs_S&SessionID", "SessAggCandCmpItemMarkIDs_S&SessionID", "SessAssCmpItemMarks_S&SessionID",
				  "SessionAssessmentComponents", "Sessions",
				  "&FacilitiesByQuartile", "&ItemFreq", "&ItemStats","&QuartileSummary", "&ReportLastRun", "&TestFreq", "&TestSummary"
);  
quit;

proc sql;
select count (distinct table_name) 
from work.ild_schema
group by table_schema;
quit;

proc sql;
select count (*) 
from work.ild_schema
quit;

/*proc contents data=db_r.isawg out=isawg_schema noprint;*/
/*run;*/

