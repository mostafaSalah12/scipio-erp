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

<p>NOTE: These report are for demonstration purposes only.
They use the JasperReports reporting tool. They have not been polished yet, but
they are good examples of creating detailed reports that you have a lot of
control over. special thanks for Britton LaRoche for creating the first pass of
these reports and helping to improve them.</p>

<form method="post" name="orderreportform" action="<@ofbizUrl>orderreportjasper.pdf</@ofbizUrl>" target="OrderReport">
  <@field type="generic" label="From Date">
      <@htmlTemplate.renderDateTimeField name="fromDate" event="" action="" value="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="22" maxlength="25" id="fromDate1" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
  </@field>
  <@field type="generic" label="To Date">
      <@htmlTemplate.renderDateTimeField name="toDate" event="" action="" value="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="22" maxlength="25" id="t" oDate1dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
  </@field>
<#--
  <@field type="generic" label="Report">
      <select name="groupName" tabindex="14"  CLASS="stateSelectBox">
        <option value="orderStatus"></option>
        <option value="orderStatus">Orders by Order Status</option>
        <option value="ship">Orders by Ship Method</option>
        <option value="payment">Orders by Payment Method</option>
        <option value="adjustment">Order Items by Adjustment</option>
        <option value="itemStatus">Order Items by Status</option>
        <option value="product">Order Items by Product</option>
      </select>
  </@field>
-->
  <@field type="submitarea">
      <input type="submit" tabindex="16" name="GoReport" value="Order Report" class="${styles.link_run_sys!} ${styles.action_export!}"/>
  </@field>
</form>

<form method="post" name="itemreportform" action="<@ofbizUrl>orderitemreportjasper.pdf</@ofbizUrl>" target="OrderReport">
  <@field type="generic" label="From Date">
      <@htmlTemplate.renderDateTimeField name="fromDate" event="" action="" value="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="22" maxlength="25" id="fromDate2" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
  </@field>
  <@field type="generic" label="To Date">
      <@htmlTemplate.renderDateTimeField name="toDate" event="" action="" value="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="22" maxlength="25" id="toDate2" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
  </@field>
<#--
  <@field type="generic" label="Report">
      <select name="groupName" tabindex="14"  class="stateSelectBox">
        <option value="orderStatus"></option>
        <option value="orderStatus">Orders by Order Status</option>
        <option value="ship">Orders by Ship Method</option>
        <option value="payment">Orders by Payment Method</option>
        <option value="adjustment">Order Items by Adjustment</option>
        <option value="itemStatus">Order Items by Status</option>
        <option value="product">Order Items by Product</option>
      </select>
  </@field>
-->
  <@field type="submitarea">
      <input type="submit" tabindex="16" name="GoReport" value="Item Report"  class="${styles.link_run_sys!} ${styles.action_export!}"/>
  </@field>
</form>
