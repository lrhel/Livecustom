--転生のペンデュラムグラフ
--Creation Pendulumgraph
--Created and scripted by Eerie Code
function c210220068.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c210220068.reltg)
	e2:SetValue(c210220068.sumlimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	e4:SetValue(c210220068.esumlimit)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,210220068)
	e5:SetTarget(c210220068.thtg)
	e5:SetOperation(c210220068.thop)
	c:RegisterEffect(e5)
end
function c210220068.reltg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c210220068.sumlimit(e,c)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer())
end
function c210220068.esumlimit(re,rp,c)
	if not c then return false end
	return not c:IsControler(rp)
end
function c210220068.thfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsControler(tp) 
		and ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) or not c:IsLocation(LOCATION_DECK))
		and c:GetPreviousControler()==tp and c:IsAbleToHand()
end
function c210220068.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and eg:IsExists(c210220068.thfilter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c210220068.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c210220068.thfilter,nil,tp)
	if g:GetCount()==0 then return end
	local tc=nil
	if g:GetCount()==1 then
		tc=g:GetFirst()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.ConfirmCards(1-tp,tc)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
