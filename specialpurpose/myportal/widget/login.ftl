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

<#if requestAttributes.uiLabelMap??><#assign uiLabelMap = requestAttributes.uiLabelMap></#if>
<#assign useMultitenant = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "multitenant")>

<#assign username = requestParameters.USERNAME?default((sessionAttributes.autoUserLogin.userLoginId)?default(""))>
<#if username != "">
  <#assign focusName = false>
<#else>
  <#assign focusName = true>
</#if>

<@row>
<@cell class="${styles.grid_large!}6 ${styles.grid_large!}centered" id="login">
  <@section title="${uiLabelMap.CommonRegistered}" titleClass="h1" class="+login-screenlet">
      <form method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform">

      <@row>
        <@cell>
          <@row collapse=true>
            <@cell columns=3>
                <span class="prefix">${uiLabelMap.CommonUsername}</span>
            </@cell>
            <@cell columns=9>
                <input type="text" name="USERNAME" value="${username}" size="20"/>
            </@cell>
          </@row>
        </@cell>
      </@row>       
   
      <@row>
        <@cell>
          <@row collapse=true>
            <@cell columns=3>
                <span class="prefix">${uiLabelMap.CommonPassword}</span>
            </@cell>
            <@cell columns=9>
                <input type="password" name="PASSWORD" value="" size="20"/>            
            </@cell>
          </@row>
        </@cell>
      </@row>   
       
          <#if ("Y" == useMultitenant) >
            <#if !requestAttributes.userTenantId??>
              <@row>
                <@cell>
                  <@row collapse=true>
                    <@cell columns=3>
                        <span class="prefix">${uiLabelMap.CommonTenantId}</span>
                    </@cell>
                    <@cell columns=9>
                        <input type="text" name="userTenantId" value="${parameters.userTenantId!}" size="20"/>
                    </@cell>
                  </@row>
                </@cell>
              </@row>   
            <#else>
                <input type="hidden" name="userTenantId" value="${requestAttributes.userTenantId!}"/>
            </#if>
          </#if>

        <@row>
            <@cell class="${styles.grid_large!}6 ${styles.text_left!}">
                <a href="<@ofbizUrl>forgotPassword</@ofbizUrl>">${uiLabelMap.CommonForgotYourPassword}?</a>
            </@cell>
            <@cell class="${styles.grid_large!}6 ${styles.text_right!}">
                <input type="submit" value="${uiLabelMap.CommonLogin}" class="${styles.link_run_session!} ${styles.action_login!}"/>
                <a href="<@ofbizUrl>newRegisterLogin</@ofbizUrl>" class="${styles.link_nav!} ${styles.action_register!}">${uiLabelMap.MyPortalNewRegistration}</a>
            </@cell>
        </@row>

        <input type="hidden" name="JavaScriptEnabled" value="N"/>

      </form>
  </@section>
</@cell>
</@row>

<@script>
  document.loginform.JavaScriptEnabled.value = "Y";
  <#if focusName>
    document.loginform.USERNAME.focus();
  <#else>
    document.loginform.PASSWORD.focus();
  </#if>
</@script>
