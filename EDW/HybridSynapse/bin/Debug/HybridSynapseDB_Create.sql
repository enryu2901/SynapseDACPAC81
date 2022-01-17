﻿/*
Deployment script for HybridSynapseDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

SET ANSI_NULLS ON;

SET ANSI_PADDING ON;

SET ANSI_WARNINGS ON;

SET ARITHABORT ON;

SET CONCAT_NULL_YIELDS_NULL ON;

SET QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "HybridSynapseDB"
:setvar DefaultFilePrefix "HybridSynapseDB"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
    END


GO
/* Please run the below section of statements against 'master' database. */
PRINT N'Creating database $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
    (EDITION = 'DataWarehouse', SERVICE_OBJECTIVE = 'DW100c')
GO
DECLARE  @job_state INT = 0;
DECLARE  @index INT = 0;
DECLARE @EscapedDBNameLiteral sysname = N'$(DatabaseName)'
WAITFOR DELAY '00:00:30';
WHILE (@index < 60) 
BEGIN
	SET @job_state = ISNULL( (SELECT SUM (result)  FROM (
		SELECT TOP 1 [state] AS result
		FROM sys.dm_operation_status WHERE resource_type = 0 
		AND operation = 'CREATE DATABASE' AND major_resource_id = @EscapedDBNameLiteral AND [state] = 2
		ORDER BY start_time DESC
		) r), -1);

	SET @index = @index + 1;

	IF @job_state = 0 /* pending */ OR @job_state = 1 /* in progress */ OR @job_state = -1 /* job not found */ OR (SELECT [state] FROM sys.databases WHERE name = @EscapedDBNameLiteral) <> 0
		WAITFOR DELAY '00:00:30';
	ELSE 
    	BREAK;
END
GO
/* Please run the below section of statements against the database name that the above [$(DatabaseName)] variable is assigned to. */
PRINT N'Creating Schema [technical]...';


GO
CREATE SCHEMA [technical]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating Table [technical].[person]...';


GO
CREATE TABLE [technical].[person] (
    [id]   INT           NULL,
    [name] VARCHAR (100) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);


GO
PRINT N'Update complete.';


GO
