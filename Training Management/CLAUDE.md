# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Build & Quality:**
- `npm run lint` - Run ESLint on LWC and Aura components
- `npm run prettier` - Format all code (Apex, XML, JavaScript, etc.)
- `npm run prettier:verify` - Check code formatting without fixing

**Testing:**
- `npm run test` - Run all LWC unit tests
- `npm run test:unit:watch` - Run tests in watch mode during development
- `npm run test:unit:coverage` - Generate test coverage reports

**Salesforce CLI Commands:**
- `sfdx force:source:push` - Deploy local changes to scratch org
- `sfdx force:source:pull` - Pull changes from scratch org
- `sfdx force:apex:test:run` - Run Apex tests in org
- `sfdx force:org:create -f config/project-scratch-def.json` - Create scratch org

## Architecture Overview

**Data Model (3-object relationship):**
- `Training_Course__c` - Course catalog with scheduling and capacity
- `Training_Enrollment__c` - Junction connecting customers to courses with progress tracking
- `Training_Certificate__c` - Certificates issued upon course completion
- Uses standard `Contact` object for customer management

**Backend Pattern:**
- `TrainingController.cls` - Single Apex controller exposing @AuraEnabled methods
- `CertificateController.cls` - Dedicated controller for certificate operations
- Methods are cacheable where appropriate for performance
- Implements "with sharing" security model
- All customer interactions go through Contact object

**Frontend Architecture:**
- `courseCatalog` LWC - Main course browser with search/filtering
- `enrollmentModal` LWC - Customer selection and enrollment workflow  
- `customerDashboard` LWC - Customer training overview with stats and progress tracking
- Parent-child communication via custom events
- Uses @wire decorators for reactive data binding to Apex methods

**Key Data Flows:**
1. Course display: `getActiveCourses()` → courseCatalog component → course cards
2. Enrollment: courseCatalog → enrollmentModal → `enrollCustomerInCourse()` → refresh
3. Customer search: enrollmentModal → `getCustomers()` with SOQL LIKE search
4. Customer dashboard: `getCustomerEnrollments()` + `getCustomerCertificates()` → progress display

## Project Structure

**Custom Objects:** `force-app/main/default/objects/`
- Each object has dedicated folders for fields, layouts, and list views
- Auto-number field pattern used for Training_Enrollment__c

**Lightning Components:** `force-app/main/default/lwc/`
- Each component includes `.js`, `.html`, `.js-meta.xml` and `__tests__/` folder
- Jest tests are scaffolded but need implementation

**Page Layouts:** `force-app/main/default/flexipages/`
- Custom record page for Training_Course__c
- Home page and utility bar configurations

**Security:** `force-app/main/default/permissionsets/`
- Single permission set grants full access to all custom objects and tabs

## Development Setup

**Pre-commit Automation:**
- Husky runs prettier, ESLint, and Jest tests on commit
- lint-staged processes only changed files
- All tests must pass before commit succeeds

**API Version:** 64.0 (Winter '24)

**Required Tools:**
- Salesforce CLI (sfdx)
- Node.js with npm
- VS Code with Salesforce Extension Pack recommended

## Salesforce DX MCP Integration

**Setup:**
- MCP Server: `@salesforce/mcp@0.17.0` (already installed globally)
- Configuration: `.mcp-config.json` configures MCP to use "TrainingManagement" scratch org
- Default org: `TrainingManagement` (scratch org, expires 2025-08-28)

**Available MCP Tools:**
- Salesforce metadata operations (retrieve, deploy, describe)
- SOQL query execution and data manipulation
- Apex code execution and testing
- Org management and configuration
- All standard SFDX CLI functionality through MCP interface

**Usage:**
- MCP tools are automatically available in Claude Code sessions
- Use MCP tools for direct Salesforce operations without manual CLI commands
- All operations target the configured default org unless otherwise specified