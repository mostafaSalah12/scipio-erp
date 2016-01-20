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
<div>
  <input type="hidden" id="partyIdentificationTypeId" name="partyIdentificationTypeId" value="">
  <label for="searchPartyBy"><b>&nbsp;${uiLabelMap.WebPosSearchBy}</b></label>
  <select id="searchPartyBy" name="searchPartyBy">
    <option value="lastName" selected>${uiLabelMap.PartyLastName}</option>
    <option value="firstName">${uiLabelMap.PartyFirstName}</option>
    <option value="idValue">${uiLabelMap.PartyPartyIdentification}</option>
  </select>
  <br/>
  <input type="text" id="partyToSearch" name="partyToSearch" size="30" maxlength="100">
  <input type="submit" value="${uiLabelMap.CommonSearch}" id="partySearchConfirm" class="${styles.link_run_sys!} ${styles.action_find!}"/>
  <br/>
</div>
<@script>
  partyKeyEvents();
</@script>