<@section menuContent=menuContent>
    <#if invalidProductId??>
        <@commonMsg type="error">${invalidProductId}</@commonMsg>
    </#if>

    <#-- Receiving Results -->
    <#if receivedItems?has_content>
        <@section title="${uiLabelMap.ProductReceiptPurchaseOrder} ${purchaseOrder.orderId}">
            <@table type="data-list"> <#-- orig: class="basic-table" --> <#-- orig: cellspacing="0" -->
                <@thead>
                    <@tr class="header-row">
                      <@th>${uiLabelMap.ProductShipmentId}</@th>
                      <@th>${uiLabelMap.ProductReceipt}</@th>
                      <@th>${uiLabelMap.CommonDate}</@th>
                      <@th>${uiLabelMap.ProductPo}</@th>
                      <@th>${uiLabelMap.ProductLine}</@th>
                      <@th>${uiLabelMap.ProductProductId}</@th>
                      <@th>${uiLabelMap.ProductLotId}</@th>
                      <@th>${uiLabelMap.ProductPerUnitPrice}</@th>
                      <@th>${uiLabelMap.CommonRejected}</@th>
                      <@th>${uiLabelMap.CommonAccepted}</@th>
                      <@th></@th>
                    </@tr>
                </@thead>
                <#list receivedItems as item>
                    <form name="cancelReceivedItemsForm_${item_index}" method="post" action="<@ofbizUrl>cancelReceivedItems</@ofbizUrl>">
                        <input type="hidden" name="receiptId" value="${(item.receiptId)!}"/>
                        <input type="hidden" name="purchaseOrderId" value="${(item.orderId)!}"/>
                        <input type="hidden" name="facilityId" value="${facilityId!}"/>
                        <@tr>
                            <@td><a href="<@ofbizUrl>ViewShipment?shipmentId=${item.shipmentId!}</@ofbizUrl>" class="${styles.link_nav_info_id_long!}">${item.shipmentId!} ${item.shipmentItemSeqId!}</a></@td>
                            <@td>${item.receiptId}</@td>
                            <@td>${item.getString("datetimeReceived").toString()}</@td>
                            <@td><a href="<@ofbizInterWebappUrl>/ordermgr/control/orderview?orderId=${item.orderId}</@ofbizInterWebappUrl>" class="${styles.link_nav_info_id!}">${item.orderId}</a></@td>
                            <@td>${item.orderItemSeqId}</@td>
                            <@td>${item.productId?default("Not Found")}</@td>
                            <@td>${item.lotId!""}</@td>
                            <@td>${(item.unitCost!0)?string("##0.00")}</@td>
                            <@td>${(item.quantityRejected!0)?string.number}</@td>
                            <@td>${item.quantityAccepted?string.number}</@td>
                            <@td>
                                <#if (item.quantityAccepted?int > 0 || item.quantityRejected?int > 0)>
                                  <a href="javascript:document.cancelReceivedItemsForm_${item_index}.submit();" class="${styles.link_run_sys!} ${styles.action_terminate!}">${uiLabelMap.CommonCancel}</a>
                                </#if>
                            </@td>
                        </@tr>
                    </form>
                </#list>
                <@tr type="util"><@td colspan="10"><hr /></@td></@tr>
            </@table>
        </@section>
    </#if>

    <#-- Single Product Receiving -->
    <#if product?has_content>
        <@section>
            <form method="post" action="<@ofbizUrl>receiveSingleInventoryProduct</@ofbizUrl>" name="selectAllForm">
                <#-- general request fields -->
                <input type="hidden" name="facilityId" value="${requestParameters.facilityId!}"/>
                <input type="hidden" name="purchaseOrderId" value="${requestParameters.purchaseOrderId!}"/>
                <#-- special service fields -->
                <input type="hidden" name="productId" value="${requestParameters.productId!}"/>
                <#if purchaseOrder?has_content>
                    <#assign unitCost = firstOrderItem.unitPrice?default(standardCosts.get(firstOrderItem.productId)?default(0))/>
                    <input type="hidden" name="orderId" value="${purchaseOrder.orderId}"/>
                    <input type="hidden" name="orderItemSeqId" value="${firstOrderItem.orderItemSeqId}"/>
                    <@field type="display" label=uiLabelMap.ProductPurchaseOrder>
                        <b>${purchaseOrder.orderId}</b>&nbsp;/&nbsp;<b>${firstOrderItem.orderItemSeqId}</b>
                        <#if 1 < purchaseOrderItems.size()>
                            (${uiLabelMap.ProductMultipleOrderItemsProduct} - ${purchaseOrderItems.size()}:1 ${uiLabelMap.ProductItemProduct})
                        <#else>
                            (${uiLabelMap.ProductSingleOrderItemProduct} - 1:1 ${uiLabelMap.ProductItemProduct})
                        </#if>
                    </@field>
                </#if>
                <@field type="display" label=uiLabelMap.ProductProductId>
                    <b>${requestParameters.productId!}</b>
                </@field>
                <@field type="display" label=uiLabelMap.ProductProductName>
                    <a href="<@ofbizInterWebappUrl>/catalog/control/ViewProduct?productId=${product.productId}${externalKeyParam!}</@ofbizInterWebappUrl>" target="catalog" class="${styles.link_nav_info_name!}">${product.internalName!}</a>
                </@field>
                <@field type="display" label=uiLabelMap.ProductProductDescription>
                    ${product.description!}
                </@field>
                <@field type="input" label=uiLabelMap.ProductItemDescription name="itemDescription" size="30" maxlength="60"/>
                <@field type="select" label=uiLabelMap.ProductInventoryItemType name="inventoryItemTypeId" size="1">
                    <#list inventoryItemTypes as nextInventoryItemType>
                        <option value="${nextInventoryItemType.inventoryItemTypeId}"<#rt>
                        <#if (facility.defaultInventoryItemTypeId?has_content) && (nextInventoryItemType.inventoryItemTypeId == facility.defaultInventoryItemTypeId)> selected="selected"</#if>><#t>
                        ${nextInventoryItemType.get("description",locale)?default(nextInventoryItemType.inventoryItemTypeId)}</option><#lt>
                    </#list>
                </@field>

                <hr />
          
                <@field type="lookup" label=uiLabelMap.ProductFacilityOwner formName="selectAllForm" name="ownerPartyId" id="ownerPartyId" fieldFormName="LookupPartyName"/>
                <@field type="select" label=uiLabelMap.ProductSupplier name="partyId">
                    <option value=""></option>
                    <#if supplierPartyIds?has_content>
                        <#list supplierPartyIds as supplierPartyId>
                            <option value="${supplierPartyId}"<#if supplierPartyId == (parameters.partyId!)> selected="selected"</#if>>
                                [${supplierPartyId}] ${Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, supplierPartyId, true)}
                            </option>
                        </#list>
                    </#if>
                </@field>
                <@field type="generic" label=uiLabelMap.ProductDateReceived>
                    <@field type="input" name="datetimeReceived" size="24" value=nowTimestamp />
                    <#-- <a href="#" onclick="setNow('datetimeReceived')" class="${styles.link_run_local!} ${styles.action_update!}">[Now]</a> -->
                </@field>
          
                <@field type="input" label=uiLabelMap.lotId name="lotId" size="10"/>

                <#-- facility location(s) -->
                <#assign facilityLocations = (product.getRelated("ProductFacilityLocation", {"facilityId":facilityId}, null, false))!/>
                <@field type="generic" label=uiLabelMap.ProductFacilityLocation>
                    <#if facilityLocations?has_content>
                        <@field type="select" name="locationSeqId">
                            <#list facilityLocations as productFacilityLocation>
                                <#assign facility = productFacilityLocation.getRelatedOne("Facility", true)/>
                                <#assign facilityLocation = productFacilityLocation.getRelatedOne("FacilityLocation", false)!/>
                                <#assign facilityLocationTypeEnum = (facilityLocation.getRelatedOne("TypeEnumeration", true))!/>
                                <option value="${productFacilityLocation.locationSeqId}"><#if facilityLocation??>${facilityLocation.areaId!}:${facilityLocation.aisleId!}:${facilityLocation.sectionId!}:${facilityLocation.levelId!}:${facilityLocation.positionId!}</#if><#if facilityLocationTypeEnum??>(${facilityLocationTypeEnum.get("description",locale)})</#if>[${productFacilityLocation.locationSeqId}]</option>
                            </#list>
                            <option value="">${uiLabelMap.ProductNoLocation}</option>
                        </@field>
                    <#else>
                        <#if parameters.facilityId??>
                            <#assign LookupFacilityLocationView="LookupFacilityLocation?facilityId=${facilityId}">
                        <#else>
                            <#assign LookupFacilityLocationView="LookupFacilityLocation">
                        </#if>
                        <@field type="lookup" formName="selectAllForm" name="locationSeqId" id="locationSeqId" fieldFormName="${LookupFacilityLocationView}"/>
                    </#if>
                </@field>
                <@field type="select" label=uiLabelMap.ProductRejectedReason name="rejectionId" size="1">
                    <option></option>
                    <#list rejectReasons as nextRejection>
                        <option value="${nextRejection.rejectionId}">${nextRejection.get("description",locale)?default(nextRejection.rejectionId)}</option>
                    </#list>
                </@field>
                <@field type="input" label=uiLabelMap.ProductQuantityRejected name="quantityRejected" size="5" value="0" />
                <@field type="input" label=uiLabelMap.ProductQuantityAccepted name="quantityAccepted" size="5" value=defaultQuantity?default(1)?string.number/>
                <#-- get the default unit cost -->
                <#if (!unitCost?? || unitCost == 0.0)><#assign unitCost = standardCosts.get(product.productId)?default(0)/></#if>
                <@field type="input" label=uiLabelMap.ProductPerUnitPrice name="unitCost" size="10" value=unitCost/>
                <@field type="submit" text=uiLabelMap.CommonReceive class="+${styles.link_run_sys!} ${styles.action_receive!}" />
                <@script>
                    document.selectAllForm.quantityAccepted.focus();
                </@script>
            </form>
        </@section>
    <#-- Select Shipment Screen -->
    <#elseif !requestParameters.shipmentId??>
        <@section title=uiLabelMap.ProductSelectShipmentReceive>
            <form method="post" action="<@ofbizUrl>ReceiveInventory</@ofbizUrl>" name="selectAllForm">
                <#-- general request fields -->
                <input type="hidden" name="facilityId" value="${requestParameters.facilityId!}"/>
                <input type="hidden" name="purchaseOrderId" value="${requestParameters.purchaseOrderId!}"/>
                <input type="hidden" name="initialSelected" value="Y"/>
                <input type="hidden" name="partialReceive" value="${partialReceive!}"/>
                <@table type="data-list" autoAltRows=true scrollable=true responsive=true>
                    <@thead>
                        <@th>${uiLabelMap.ProductShipmentId}</@th>
                        <@th>${uiLabelMap.ProductShipmentTypeId}</@th>
                        <@th>${uiLabelMap.ProductStatusId}</@th>
                        <@th>${uiLabelMap.ProductOriginFacility}</@th>
                        <@th>${uiLabelMap.ProductDestinationFacility}</@th>                        
                        <@th>${uiLabelMap.ProductEstimatedArrivalDate}</@th>                        
                    </@thead>
                    <#list shipments! as shipment>
                        <#assign originFacility = shipment.getRelatedOne("OriginFacility", true)!/>
                        <#assign destinationFacility = shipment.getRelatedOne("DestinationFacility", true)!/>
                        <#assign statusItem = shipment.getRelatedOne("StatusItem", true)/>
                        <#assign shipmentType = shipment.getRelatedOne("ShipmentType", true)/>
                        <#assign shipmentDate = shipment.estimatedArrivalDate!/>
                        <@tr>
                            <@td><@field type="radio" name="shipmentId" value="${shipment.shipmentId}">${shipment.shipmentId}</@field></@td>                            
                            <@td>${shipmentType.get("description",locale)?default(shipmentType.shipmentTypeId?default(""))}</@td>
                            <@td>${statusItem.get("description",locale)?default(statusItem.statusId!(uiLabelMap.CommonNA))}</@td>
                            <@td>${(originFacility.facilityName)!} [${shipment.originFacilityId!}]</@td>
                            <@td>${(destinationFacility.facilityName)!} [${shipment.destinationFacilityId!}]</@td>
                            <@td>${(shipment.estimatedArrivalDate.toString())!}</@td>
                        </@tr>
                    </#list>
                    <@tr>
                        <@td><input type="radio" name="shipmentId" value="_NA_" /></@td>
                        <@td>${uiLabelMap.ProductNoSpecificShipment}</@td>
                        <@td colspan="5"></@td>
                    </@tr>
                </@table>
                <@field type="submit" submitType="link" href="javascript:document.selectAllForm.submit();" class="+${styles.link_run_sys!} ${styles.action_receive!}" text=uiLabelMap.ProductReceiveSelectedShipment />
            </form>
        </@section>
    <#-- Multi-Item PO Receiving -->
    <#elseif purchaseOrder?has_content>
            <@section>
                <input type="hidden" id="getConvertedPrice" value="<@ofbizUrl>getConvertedPrice"</@ofbizUrl> />
                <input type="hidden" id="alertMessage" value="${uiLabelMap.ProductChangePerUnitPrice}" />
                <form method="post" action="<@ofbizUrl>receiveInventoryProduct</@ofbizUrl>" name="selectAllForm">
                    <#-- general request fields -->
                    <input type="hidden" name="facilityId" value="${requestParameters.facilityId!}"/>
                    <input type="hidden" name="purchaseOrderId" value="${requestParameters.purchaseOrderId!}"/>
                    <input type="hidden" name="initialSelected" value="Y"/>
                    <#if shipment?has_content>
                        <input type="hidden" name="shipmentIdReceived" value="${shipment.shipmentId}"/>
                    </#if>
                    <input type="hidden" name="_useRowSubmit" value="Y"/>
                    <#assign rowCount = 0/>
                    <#if !purchaseOrderItems?? || purchaseOrderItems.size() == 0>
                        <@commonMsg type="result-norecord">${uiLabelMap.ProductNoItemsPoReceive}.</@commonMsg>
                    <#else>
                        <@fields type="default-manual-widgetonly">
                            <@table type="data-list" autoAltRows=true scrollable=true responsive=true> <#-- orig: class="basic-table" --> <#-- orig: cellspacing="0" -->
                                <@thead>
                                    <@tr>
                                        <@th>${uiLabelMap.ProductReceivePurchaseOrder} #${purchaseOrder.orderId}</@th>
                                        <@th>
                                            <#if shipment?has_content>
                                                ${uiLabelMap.ProductShipmentId} #${shipment.shipmentId}                                            
                                                <@field type="checkbox" name="forceShipmentReceived" value="Y" label="Set Shipment As Received"/>
                                            </#if>
                                        </@th>
                                        <@th>
                                            ${uiLabelMap.CommonSelectAll}
                                            <@field type="checkbox" name="selectAll" value="Y" onClick="javascript:toggleAll(this, 'selectAllForm');"/>
                                        </@th>
                                    </@tr>
                                </@thead>
                                <#list purchaseOrderItems as orderItem>
                                    <#assign defaultQuantity = orderItem.quantity - receivedQuantities[orderItem.orderItemSeqId]?double/>
                                    <#assign itemCost = orderItem.unitPrice?default(0)/>
                                    <#assign salesOrderItem = salesOrderItems[orderItem.orderItemSeqId]!/>
                                    <#if shipment?has_content>
                                        <#if shippedQuantities[orderItem.orderItemSeqId]??>
                                            <#assign defaultQuantity = shippedQuantities[orderItem.orderItemSeqId]?double - receivedQuantities[orderItem.orderItemSeqId]?double/>
                                        <#else>
                                            <#assign defaultQuantity = 0/>
                                        </#if>
                                    </#if>
                                    <#if 0 < defaultQuantity>
                                        <#assign orderItemType = orderItem.getRelatedOne("OrderItemType", false)/>
                                        <input type="hidden" name="orderId_o_${rowCount}" value="${orderItem.orderId}"/>
                                        <input type="hidden" name="orderItemSeqId_o_${rowCount}" value="${orderItem.orderItemSeqId}"/>
                                        <input type="hidden" name="facilityId_o_${rowCount}" value="${requestParameters.facilityId!}"/>
                                        <input type="hidden" name="datetimeReceived_o_${rowCount}" value="${nowTimestamp}"/>
                                        <#if shipment?? && shipment.shipmentId?has_content>
                                            <input type="hidden" name="shipmentId_o_${rowCount}" value="${shipment.shipmentId}"/>
                                        </#if>
                                        <#if salesOrderItem?has_content>
                                            <input type="hidden" name="priorityOrderId_o_${rowCount}" value="${salesOrderItem.orderId}"/>
                                            <input type="hidden" name="priorityOrderItemSeqId_o_${rowCount}" value="${salesOrderItem.orderItemSeqId}"/>
                                        </#if>
                                        
                                        <@tr>
                                            <@td>
                                                <@table type="fields"> <#-- orig: class="basic-table" --> <#-- orig: cellspacing="0" -->
                                                    <@tr>
                                                        <#if orderItem.productId??>
                                                            <#assign product = orderItem.getRelatedOne("Product", true)/>
                                                            <input type="hidden" name="productId_o_${rowCount}" value="${product.productId}"/>
                                                            <@td>
                                                                ${orderItem.orderItemSeqId}:&nbsp;<a href="<@ofbizInterWebappUrl>/catalog/control/ViewProduct?productId=${product.productId}${externalKeyParam!}</@ofbizInterWebappUrl>" target="catalog" class="${styles.link_nav_info_desc!}">${product.productId}&nbsp;-&nbsp;${orderItem.itemDescription!}</a> : ${product.description!}
                                                            </@td>
                                                        <#else>
                                                            <@td>
                                                                <b>${orderItemType.get("description",locale)}</b> : ${orderItem.itemDescription!}&nbsp;&nbsp;
                                                                <@field type="input" size="12" name="productId_o_${rowCount}"/>
                                                                <a href="<@ofbizInterWebappUrl>/catalog/control/ViewProduct?${rawString(externalKeyParam)}</@ofbizInterWebappUrl>" target="catalog" class="${styles.link_nav!} ${styles.action_add!}">${uiLabelMap.ProductCreateProduct}</a>
                                                            </@td>
                                                        </#if>
                                                        <@td>${uiLabelMap.ProductLocation}:</@td>
                                                        <#-- location(s) -->
                                                        <@td>
                                                            <#assign facilityLocations = (orderItem.getRelated("ProductFacilityLocation", {"facilityId":facilityId}, null, false))!/>
                                                            <#if facilityLocations?has_content>
                                                                <@field type="select" name="locationSeqId_o_${rowCount}">
                                                                    <#list facilityLocations as productFacilityLocation>
                                                                        <#assign facility = productFacilityLocation.getRelatedOne("Facility", true)/>
                                                                        <#assign facilityLocation = productFacilityLocation.getRelatedOne("FacilityLocation", false)!/>
                                                                        <#assign facilityLocationTypeEnum = (facilityLocation.getRelatedOne("TypeEnumeration", true))!/>
                                                                        <option value="${productFacilityLocation.locationSeqId}"><#if facilityLocation??>${facilityLocation.areaId!}:${facilityLocation.aisleId!}:${facilityLocation.sectionId!}:${facilityLocation.levelId!}:${facilityLocation.positionId!}</#if><#if facilityLocationTypeEnum??>(${facilityLocationTypeEnum.get("description",locale)})</#if>[${productFacilityLocation.locationSeqId}]</option>
                                                                    </#list>
                                                                    <option value="">${uiLabelMap.ProductNoLocation}</option>
                                                                </@field>
                                                            <#else>
                                                                <#if parameters.facilityId??>
                                                                    <#assign LookupFacilityLocationView="LookupFacilityLocation?facilityId=${facilityId}">
                                                                <#else>
                                                                    <#assign LookupFacilityLocationView="LookupFacilityLocation">
                                                                </#if>
                                                                <@field type="lookup" formName="selectAllForm" name="locationSeqId_o_${rowCount}" id="locationSeqId_o_${rowCount}" fieldFormName="${LookupFacilityLocationView}"/>
                                                            </#if>
                                                        </@td>
                                                        <@td>${uiLabelMap.ProductQtyReceived} :</@td>
                                                        <@td>
                                                            <#assign fieldValue><#if partialReceive??>0<#else>${defaultQuantity?string.number}</#if></#assign>
                                                            <@field type="input" name="quantityAccepted_o_${rowCount}" size="6" value=fieldValue />
                                                        </@td>
                                                    </@tr>
                                                    <@tr>
                                                        <@td >
                                                            ${uiLabelMap.ProductInventoryItemType} :&nbsp;
                                                            <@field type="select" name="inventoryItemTypeId_o_${rowCount}" size="1">
                                                                <#list inventoryItemTypes as nextInventoryItemType>
                                                                    <option value="${nextInventoryItemType.inventoryItemTypeId}"<#rt>
                                                                    <#if (facility.defaultInventoryItemTypeId?has_content) && (nextInventoryItemType.inventoryItemTypeId == facility.defaultInventoryItemTypeId)> selected="selected"</#if>><#t>
                                                                    ${nextInventoryItemType.get("description",locale)?default(nextInventoryItemType.inventoryItemTypeId)}</option><#lt>
                                                                </#list>
                                                            </@field>
                                                          </@td>
                                                          <@td>${uiLabelMap.ProductRejectionReason} :</@td>
                                                          <@td>
                                                                <@field type="select" name="rejectionId_o_${rowCount}" size="1">
                                                                    <option></option>
                                                                    <#list rejectReasons as nextRejection>
                                                                        <option value="${nextRejection.rejectionId}">${nextRejection.get("description",locale)?default(nextRejection.rejectionId)}</option>
                                                                    </#list>
                                                                </@field>
                                                          </@td>
                                                          <@td>${uiLabelMap.ProductQtyRejected} :</@td>
                                                          <@td>
                                                                <@field type="input" name="quantityRejected_o_${rowCount}" value="0" size="6"/>
                                                          </@td>
                                                    </@tr>
                                                    <@tr>
                                                        <@td>&nbsp;</@td>
                                                        <#if !product.lotIdFilledIn?has_content || product.lotIdFilledIn != "Forbidden">
                                                            <@td>${uiLabelMap.ProductLotId}</@td>
                                                            <@td>
                                                                <@field type="input" name="lotId_o_${rowCount}" size="20" />
                                                            </@td>
                                                        <#else>
                                                            <@td>&nbsp;</@td>
                                                            <@td>&nbsp;</@td>
                                                        </#if>
                                                        <@td>${uiLabelMap.OrderQtyOrdered} :</@td>
                                                        <@td>
                                                            <@field type="input" name="quantityOrdered" value=orderItem.quantity size="6" maxlength="20" disabled="disabled" />
                                                        </@td>
                                                            
                                                    </@tr>
                                                    <@tr>
                                                        <@td>&nbsp;</@td>
                                                        <@td>${uiLabelMap.ProductFacilityOwner}:</@td>
                                                        <@td><input type="text" name="ownerPartyId_o_${rowCount}" size="20" maxlength="20" value="${facility.ownerPartyId}"/></@td>
                                                        <#if (currencyUomId!'') != (orderCurrencyUomId!'')>
                                                            <@td>${uiLabelMap.ProductPerUnitPriceOrder}:</@td>
                                                            <@td>
                                                                <input type="hidden" name="orderCurrencyUomId_o_${rowCount}" value="${orderCurrencyUomId!}" />
                                                                <@field type="input" id="orderCurrencyUnitPrice_${rowCount}" name="orderCurrencyUnitPrice_o_${rowCount}" value=orderCurrencyUnitPriceMap[orderItem.orderItemSeqId] onChange="javascript:getConvertedPrice(orderCurrencyUnitPrice_${rowCount}, '${orderCurrencyUomId}', '${currencyUomId}', '${rowCount}', '${orderCurrencyUnitPriceMap[orderItem.orderItemSeqId]}', '${itemCost}');" size="6" maxlength="20" />
                                                                ${orderCurrencyUomId!}
                                                            </@td>
                                                            <@td>${uiLabelMap.ProductPerUnitPriceFacility}:</@td>
                                                            <@td>
                                                                <input type="hidden" name="currencyUomId_o_${rowCount}" value="${currencyUomId!}" />
                                                                <@field type="input" id="unitCost_${rowCount}" name="unitCost_o_${rowCount}" value=itemCost readonly="readonly" size="6" maxlength="20" />
                                                                ${currencyUomId!}
                                                            </@td>
                                                        <#else>
                                                            <@td>${uiLabelMap.ProductPerUnitPrice}:</@td>
                                                            <@td>
                                                                <input type="hidden" name="currencyUomId_o_${rowCount}" value="${currencyUomId!}" />
                                                                <@field type="input" name="unitCost_o_${rowCount}" value=itemCost size="6" maxlength="20" />
                                                                ${currencyUomId!}
                                                            </@td>
                                                        </#if>
                                                    </@tr>
                                                </@table>
                                            </@td>
                                            <@td>
                                                 <@field type="checkbox" name="_rowSubmit_o_${rowCount}" value="Y" onClick="javascript:checkToggle(this, 'selectAllForm');"/>
                                            </@td>
                                        </@tr>
                                        <#assign rowCount = rowCount + 1>
                                    </#if>
                                </#list>
                            <@tr type="util">
                                <@td colspan="2">
                                    <hr />
                                </@td>
                            </@tr>
                            <#if rowCount == 0>
                                <@tr>
                                    <@td colspan="2">${uiLabelMap.ProductNoItemsPo} #${purchaseOrder.orderId} ${uiLabelMap.ProductToReceive}.</@td>
                                </@tr>
                                <@tr>
                                    <@td colspan="2">
                                        <a href="<@ofbizUrl>ReceiveInventory?facilityId=${requestParameters.facilityId!}</@ofbizUrl>" class="${styles.link_cancel_nav!}">${uiLabelMap.ProductReturnToReceiving}</a>
                                    </@td>
                                </@tr>
                            <#else>
                                <@tr>
                                    <@td colspan="2">
                                        <@field type="submit" submitType="link" href="javascript:document.selectAllForm.submit();" class="${styles.link_run_sys!} ${styles.action_receive!}" text=uiLabelMap.ProductReceiveSelectedProduct/>
                                    </@td>
                                </@tr>
                            </#if>
                        </@table>
                    </@fields>
                </#if>
                <input type="hidden" name="_rowCount" value="${rowCount}"/>
            </form>
        </@section>
    </#if>
</@section>