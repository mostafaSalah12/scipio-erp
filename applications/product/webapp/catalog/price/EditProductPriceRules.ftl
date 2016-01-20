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
<#macro menuContent menuArgs={}>
  <@menu args=menuArgs>
    <@menuitem type="link" href=makeOfbizUrl("FindProductPriceRules") text="${uiLabelMap.ProductFindRule}" />
  </@menu>
</#macro>
<@section title="${uiLabelMap.ProductGlobalPriceRule}" menuContent=menuContent>
    <@table type="data-list" cellspacing="0"> <#-- orig: class="basic-table" -->
        <@thead>
          <@tr class="header-row">
            <@th width="10%">${uiLabelMap.ProductRuleId}</@th>
            <@th width="80%">${uiLabelMap.ProductRuleNameFromDateThruDate}</@th>
            <@th width="10%">&nbsp;</@th>
          </@tr>
        </@thead>
        <#if productPriceRule??>
          <#assign productPriceConds = productPriceRule.getRelated("ProductPriceCond", null, null, false)>
          <#assign productPriceActions = productPriceRule.getRelated("ProductPriceAction", null, null, false)>
          <@tr valign="middle">
            <@td><b>${productPriceRule.productPriceRuleId}</b></@td>
            <@td>
                <form method="post" action="<@ofbizUrl>updateProductPriceRule</@ofbizUrl>" name="updateProductPriceRule">
                    <input type="hidden" name="productPriceRuleId" value="${productPriceRule.productPriceRuleId}" />
                    <input type="text" size="15" name="ruleName" value="${productPriceRule.ruleName}" />
                    <input type="text" size="15" name="description" value="${productPriceRule.description!}" />
                    <@htmlTemplate.renderDateTimeField name="fromDate" event="" action="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="${productPriceRule.fromDate!}" size="25" maxlength="30" id="fromDate1" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                    <@htmlTemplate.renderDateTimeField name="thruDate" event="" action="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="${productPriceRule.thruDate!}" size="25" maxlength="30" id="thruDate1" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                    &nbsp;&nbsp;
                    <#assign saleRule = productPriceRule.isSale?? && productPriceRule.isSale == "Y">
                    <div>
                    <span><b>${uiLabelMap.ProductNotifySale}</b></span>&nbsp;
                    <input type="radio" name="isSale" value="Y" <#if saleRule>checked="checked"</#if> />${uiLabelMap.CommonYes}&nbsp;
                    <input type="radio" name="isSale" value="N" <#if !saleRule>checked="checked"</#if> />${uiLabelMap.CommonNo}
                    &nbsp;&nbsp;
                    <input type="submit" value="${uiLabelMap.CommonUpdate}" class="${styles.link_run_sys!} ${styles.action_update!}" />
                    </div>
                </form>
            </@td>
            <@td align="center">&nbsp;
              <#if !productPriceConds?has_content && !productPriceActions?has_content>
                  <form method="post" action="<@ofbizUrl>deleteProductPriceRule</@ofbizUrl>" name="deleteProductPriceRule">
                      <input type="hidden" name="productPriceRuleId" value="${productPriceRule.productPriceRuleId}" />
                      <input type="submit" value="${uiLabelMap.CommonDelete}" class="${styles.link_run_sys!} ${styles.action_remove!}" />
                  </form>
              </#if>
            </@td>
          </@tr>
          <@tr valign="top">
            <@td align="right">${uiLabelMap.ProductConditions}</@td>
            <@td colspan="2">
                <@table type="data-list" autoAltRows=true cellspacing="0"> <#-- orig: class="basic-table" -->
                <@thead>
                  <@tr class="header-row">
                    <@th width="5%">${uiLabelMap.ProductSeqId}</@th>
                    <@th width="85%">${uiLabelMap.ProductInputOperatorValue}</@th>
                    <@th width="10%">&nbsp;</@th>
                  </@tr>
                  </@thead>
                  <#assign maxCondSeqId = 1>
                  <#list productPriceConds as productPriceCond>
                      <@tr valign="middle">
                        <#-- if cur seq id is a number and is greater than max, set new max for input box prefill below -->
                        <#assign curCondSeqId = productPriceCond.productPriceCondSeqId?number>
                        <#if (curCondSeqId >= maxCondSeqId)><#assign maxCondSeqId = curCondSeqId + 1></#if>
                        <@td><b>${productPriceCond.productPriceCondSeqId}</b></@td>
                        <@td>
                            <form method="post" action="<@ofbizUrl>updateProductPriceCond</@ofbizUrl>">
                                <input type="hidden" name="productPriceRuleId" value="${productPriceCond.productPriceRuleId}"/>
                                <input type="hidden" name="productPriceCondSeqId" value="${productPriceCond.productPriceCondSeqId}"/>
                                <select name="inputParamEnumId" size="1">
                                    <#if productPriceCond.inputParamEnumId?has_content>
                                      <#assign inputParamEnum = productPriceCond.getRelatedOne("InputParamEnumeration", true)!>
                                      <option value="${productPriceCond.inputParamEnumId}"><#if inputParamEnum??>${inputParamEnum.get("description",locale)}<#else>[${productPriceCond.inputParamEnumId}]</#if></option>
                                      <option value="${productPriceCond.inputParamEnumId}">&nbsp;</option>
                                    <#else>
                                      <option value="">&nbsp;</option>
                                    </#if>
                                    <#list inputParamEnums as inputParamEnum>
                                      <option value="${inputParamEnum.enumId}">${inputParamEnum.get("description",locale)}<#--[${inputParamEnum.enumId}]--></option>
                                    </#list>
                                </select>
                                <select name="operatorEnumId" size="1">
                                    <#if productPriceCond.operatorEnumId?has_content>
                                      <#assign operatorEnum = productPriceCond.getRelatedOne("OperatorEnumeration", true)!>
                                      <option value="${productPriceCond.operatorEnumId}"><#if operatorEnum??>${operatorEnum.get("description",locale)}<#else>[${productPriceCond.operatorEnumId}]</#if></option>
                                      <option value="${productPriceCond.operatorEnumId}">&nbsp;</option>
                                    <#else>
                                      <option value="">&nbsp;</option>
                                    </#if>
                                    <#list condOperEnums as condOperEnum>
                                      <option value="${condOperEnum.enumId}">${condOperEnum.get("description",locale)}<#--[${condOperEnum.enumId}]--></option>
                                    </#list>
                                </select>
                                <input type="text" size="20" name="condValue" value="${productPriceCond.condValue!}" />
                                <input type="submit" value="${uiLabelMap.CommonUpdate}" class="${styles.link_run_sys!} ${styles.action_update!}" />
                            </form>
                        </@td>
                        <@td align="center">
                         <form name="deleteProductPriceCond_${productPriceCond_index}" method= "post" action= "<@ofbizUrl>deleteProductPriceCond</@ofbizUrl>">
                           <input type="hidden" name="productPriceRuleId" value="${productPriceCond.productPriceRuleId}" />
                           <input type="hidden" name="productPriceCondSeqId" value="${productPriceCond.productPriceCondSeqId}" />
                           <a href="javascript:document.deleteProductPriceCond_${productPriceCond_index}.submit()" class="${styles.link_run_sys!} ${styles.action_remove!}">${uiLabelMap.CommonDelete}</a>
                         </form>
                        </@td>
                      </@tr>
                  </#list>
                  <@tfoot>
                  <@tr>
                    <@td colspan="3">
                        <form method="post" action="<@ofbizUrl>createProductPriceCond</@ofbizUrl>">
                            <input type="hidden" name="productPriceRuleId" value="${productPriceRule.productPriceRuleId}" />
                            <span><b>${uiLabelMap.CommonNew}</b>&nbsp;</span>
                            <select name="inputParamEnumId" size="1">
                                <#list inputParamEnums as inputParamEnum>
                                  <option value="${inputParamEnum.enumId}">${inputParamEnum.get("description",locale)}<#--[${inputParamEnum.enumId}]--></option>
                                </#list>
                            </select>
                            <select name="operatorEnumId" size="1">
                                <#list condOperEnums as condOperEnum>
                                  <option value="${condOperEnum.enumId}">${condOperEnum.get("description",locale)}<#--[${condOperEnum.enumId}]--></option>
                                </#list>
                            </select>
                            <input type="text" size="20" name="condValue" />
                            <input type="submit" value="${uiLabelMap.CommonCreate}" class="${styles.link_run_sys!} ${styles.action_add!}" />
                        </form>
                    </@td>
                  </@tr>
                  </@tfoot>
                </@table>
            </@td>
          </@tr>
          <@tr valign="top">
            <@td align="right">${uiLabelMap.ProductActions}</@td>
            <@td colspan="2">
                <@table type="data-list" autoAltRows=true cellspacing="0"> <#-- orig: class="basic-table" -->
                  <@tr class="header-row">
                    <@th width="5%">${uiLabelMap.ProductSeqId}</@th>
                    <@th width="85%">${uiLabelMap.ProductActionTypeAmount}</@th>
                    <@th width="10%">&nbsp;</@th>
                  </@tr>
                  <#list productPriceActions as productPriceAction>
                      <@tr valign="middle">
                        <@td><b>${productPriceAction.productPriceActionSeqId}</b></@td>
                        <@td>
                            <form method="post" action="<@ofbizUrl>updateProductPriceAction</@ofbizUrl>">
                                <input type="hidden" name="productPriceRuleId" value="${productPriceAction.productPriceRuleId}" />
                                <input type="hidden" name="productPriceActionSeqId" value="${productPriceAction.productPriceActionSeqId}" />
                                <select name="productPriceActionTypeId" size="1">
                                    <#if productPriceAction.productPriceActionTypeId?has_content>
                                      <#assign productPriceActionType = productPriceAction.getRelatedOne("ProductPriceActionType", true)>
                                      <option value="${productPriceAction.productPriceActionTypeId}"><#if productPriceActionType??>${productPriceActionType.get("description",locale)}<#else>[${productPriceAction.productPriceActionTypeId}]</#if></option>
                                      <option value="${productPriceAction.productPriceActionTypeId}">&nbsp;</option>
                                    <#else>
                                      <option value="">&nbsp;</option>
                                    </#if>
                                    <#list productPriceActionTypes as productPriceActionType>
                                      <option value="${productPriceActionType.productPriceActionTypeId}">${productPriceActionType.get("description",locale)}<#--[${productPriceActionType.productPriceActionTypeId}]--></option>
                                    </#list>
                                </select>
                                <input type="text" size="8" name="amount" value="${productPriceAction.amount!}" />
                                <input type="submit" value="${uiLabelMap.CommonUpdate}" class="${styles.link_run_sys!} ${styles.action_update!}" />
                            </form>
                        </@td>
                        <@td align="center">
                          <form name="deleteProductPriceAction_${productPriceAction_index}" method="post" action="<@ofbizUrl>deleteProductPriceAction</@ofbizUrl>">
                            <input type="hidden" name="productPriceRuleId" value="${productPriceAction.productPriceRuleId}" />
                            <input type="hidden" name="productPriceActionSeqId" value="${productPriceAction.productPriceActionSeqId}" />
                            <a href="javascript:document.deleteProductPriceAction_${productPriceAction_index}.submit()" class="${styles.link_run_sys!} ${styles.action_remove!}">${uiLabelMap.CommonDelete}</a>
                          </form>
                        </@td>
                      </@tr>
                  </#list>
                  <@tfoot>
                  <@tr>
                    <@td colspan="3">
                        <form method="post" action="<@ofbizUrl>createProductPriceAction</@ofbizUrl>">
                            <input type="hidden" name="productPriceRuleId" value="${productPriceRule.productPriceRuleId}" />
                            <span><b>${uiLabelMap.CommonNew}</b>&nbsp;</span>
                            <select name="productPriceActionTypeId" size="1">
                                <#list productPriceActionTypes as productPriceActionType>
                                  <option value="${productPriceActionType.productPriceActionTypeId}">${productPriceActionType.get("description",locale)}<#--[${productPriceActionType.productPriceActionTypeId}]--></option>
                                </#list>
                            </select>
                            <input type="text" size="8" name="amount" />
                            <input type="submit" value="${uiLabelMap.CommonCreate}" class="${styles.link_run_sys!} ${styles.action_add!}" />
                        </form>
                    </@td>
                  </@tr>
                  </@tfoot>
                </@table>
            </@td>
          </@tr>
        </#if>
    </@table>
</@section>
