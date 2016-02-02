<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#if periods?has_content>
  <#-- Allow containing screens to specify the URL for creating a new event -->
  <#if !newCalEventUrl??>
    <#assign newCalEventUrl = parameters._LAST_VIEW_NAME_>
  </#if>
  <#if (maxConcurrentEntries < 2)>
    <#assign entryWidth = 100>
  <#else>
    <#assign entryWidth = (100 / (maxConcurrentEntries))>
  </#if>
<@table type="data-list" cellspacing="0" class="+calendar"> <#-- orig: class="basic-table calendar" -->
 <@thead>
  <@tr class="header-row">
    <@th>${uiLabelMap.CommonTime}</@th>
    <@th colspan="${maxConcurrentEntries}">${uiLabelMap.WorkEffortCalendarEntries}</@th>
  </@tr>
  </@thead>
  <#list periods as period>
    <#assign currentPeriod = false/>
    <#if (nowTimestamp >= period.start) && (nowTimestamp <= period.end)><#assign currentPeriod = true/></#if>
  <#assign class><#if currentPeriod>current-period<#else><#if (period.calendarEntries?size > 0)>active-period</#if></#if></#assign>
  <@tr class=class>
    <@td>
      ${period.start?time?string.short}<br />
      <a href="<@ofbizUrl>${newCalEventUrl}?period=day&amp;form=edit&amp;parentTypeId=${parentTypeId!}&amp;start=${parameters.start!}&amp;currentStatusId=CAL_TENTATIVE&amp;estimatedStartDate=${period.start?string("yyyy-MM-dd HH:mm:ss")}&amp;estimatedCompletionDate=${period.end?string("yyyy-MM-dd HH:mm:ss")}${urlParam!}${addlParam!}</@ofbizUrl>" class="${styles.link_run_sys!} ${styles.action_add!}">${uiLabelMap.CommonAddNew}</a>
    </@td>
      <#list period.calendarEntries as calEntry>
        <#if calEntry.workEffort.actualStartDate??>
            <#assign startDate = calEntry.workEffort.actualStartDate>
          <#else>
            <#assign startDate = calEntry.workEffort.estimatedStartDate!>
        </#if>

        <#if calEntry.workEffort.actualCompletionDate??>
            <#assign completionDate = calEntry.workEffort.actualCompletionDate>
          <#else>
            <#assign completionDate = calEntry.workEffort.estimatedCompletionDate!>
        </#if>

        <#if !completionDate?has_content && calEntry.workEffort.actualMilliSeconds?has_content>
            <#assign completionDate =  calEntry.workEffort.actualStartDate + calEntry.workEffort.actualMilliSeconds>
        </#if>    
        <#if !completionDate?has_content && calEntry.workEffort.estimatedMilliSeconds?has_content>
            <#assign completionDate =  calEntry.workEffort.estimatedStartDate + calEntry.workEffort.estimatedMilliSeconds>
        </#if>    
    
    <#if calEntry.startOfPeriod>
    <#assign rowSpan><#if (calEntry.periodSpan > 1)>${calEntry.periodSpan}</#if></#assign>
    <#assign width>${entryWidth?string("#")}%</#assign>
    <@td rowSpan=rowSpan width=width>
    <#if (startDate.compareTo(start)  <= 0 && completionDate?has_content && completionDate.compareTo(next) >= 0)>
      ${uiLabelMap.CommonAllDay}
    <#elseif startDate.before(start) && completionDate?has_content>
      ${uiLabelMap.CommonUntil} ${completionDate?time?string.short}
    <#elseif !completionDate?has_content>
      ${uiLabelMap.CommonFrom} ${startDate?time?string.short} - ?
    <#elseif completionDate.after(period.end)>
      ${uiLabelMap.CommonFrom} ${startDate?time?string.short}
    <#else>
      ${startDate?time?string.short}-${completionDate?time?string.short}
    </#if>
    <br />
    ${setRequestAttribute("periodType", "day")}
    ${setRequestAttribute("workEffortId", calEntry.workEffort.workEffortId)}
    ${screens.render("component://workeffort/widget/CalendarScreens.xml#calendarEventContent")}
    </@td>
    </#if>
    </#list>
    <#if (period.calendarEntries?size < maxConcurrentEntries)>
      <#assign emptySlots = (maxConcurrentEntries - period.calendarEntries?size)>
        <#assign colspan><#if (emptySlots > 1)>${emptySlots}</#if></#assign>
        <@td colspan=colspan>&nbsp;</@td>
    </#if>
    <#if maxConcurrentEntries = 0>
      <#assign width>${entryWidth?string("#")}%</#assign>
      <@td width=width>&nbsp;</@td>
    </#if>
  </@tr>
  </#list>
</@table>
<#else>
  <@errorMsg>${uiLabelMap.WorkEffortFailedCalendarEntries}!</@errorMsg>
</#if>
