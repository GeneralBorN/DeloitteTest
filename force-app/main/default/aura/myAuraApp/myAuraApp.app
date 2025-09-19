<aura:application extends="force:slds" controller="myAccountController">
    <aura:attribute name="showText" type="Boolean" default="false"/>
    <aura:attribute name="account" type="Account"/>
    <aura:handler name="init" value="{!this}" action="{!c.fetchRandomAccount}"/>
    <lightning:recordViewForm recordId="{!v.account.Id}" objectApiName="Account"> 
        <lightning:outputField fieldName="Name"/>
        <lightning:outputField fieldName="Phone"/>
        <lightning:outputField fieldName="Website"/>
    </lightning:recordViewForm>
    <lightning:button label="Show More Info" onclick="{!c.showMoreInfo}"/>
    <aura:if isTrue="{!v.showText}">
        <p>Additional text displayed below the button.</p>
    </aura:if>
</aura:application>
