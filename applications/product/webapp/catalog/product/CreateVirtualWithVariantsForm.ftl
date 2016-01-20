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

<@section title="${uiLabelMap.ProductQuickCreateVirtualFromVariants}">
    <form action="<@ofbizUrl>quickCreateVirtualWithVariants</@ofbizUrl>" method="post" name="quickCreateVirtualWithVariants">
        <@field type="generic" label="${uiLabelMap.ProductVariantProductIds}">
            <textarea name="variantProductIdsBag" rows="6" cols="20"></textarea>
        </@field>
        
        <@field type="generic" label="Hazmat">
            <select name="productFeatureIdOne">
                <option value="">- ${uiLabelMap.CommonNone} -</option>
                <#list hazmatFeatures as hazmatFeature>
                    <option value="${hazmatFeature.productFeatureId}">${hazmatFeature.description}</option>
                </#list>
            </select>
        </@field>  
        
        <@field type="submitarea">
            <input type="submit" value="${uiLabelMap.ProductCreateVirtualProduct}" class="${styles.link_run_sys!} ${styles.action_add!}"/>
        </@field> 
    </form>
</@section>