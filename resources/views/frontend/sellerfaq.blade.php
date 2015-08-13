@extends('layouts.frontend') 
@section('content')
<div class="content">  
      
    <div class="container">
        <h3 class="text-center semi-bold">FAQs</h3>
<div class="panel-group" id="accordion" data-toggle="collapse">
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
What is Your delivery distance?
</a>
</h4>
</div>
<div id="collapseOne" class="panel-collapse collapse in" style="height: auto;">
<div class="panel-body">
This is the distance upto which you can provide delivery service. You can just slide on the slider  provided  and choose the distance.To get more accurate distance values use the ‘+’ and “-” options.

</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
Why do i have to add categories?

</a>
</h4>
</div>
<div id="collapseTwo" class="panel-collapse collapse" style="height: 0px;">
<div class="panel-body">
You will receive requests from customers for the products which will fall under your category, so hence it will be necessary to choose all the categories you deal with.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
What is auto offer?
</a>
</h4>
</div>
<div id="collapseThree" class="panel-collapse collapse">
<div class="panel-body">
Auto offer allows you to automatically send your offers to the received request if to fail to make offer within 10 minutes from receiving it.Your last price and the last delivery time for that product will be sent to the customer.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseFour">
When do I get new requests ?
</a>
</h4>
</div>
<div id="collapseFour" class="panel-collapse collapse">
<div class="panel-body">
You shall get new requests when the customers make request for products falling under the categories and the brands you deal with.You will receive a notification for the same.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseFive">
 What do I do when I receive a new request?
</a>
</h4>
</div>
<div id="collapseFive" class="panel-collapse collapse">
<div class="panel-body">
Make an offer. All the request related details will be displayed on the request card, based on it you have to send your offer price  to the customer.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseSix">
What happens when I make an offer?
</a>
</h4>
</div>
<div id="collapseSix" class="panel-collapse collapse">
<div class="panel-body">
Your offer is sent to the customer. If the customer is happy with your offer,he will accept it and you will receive notification for the same.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseSeven">
What if the customer rejects my offer after accepting it? What if the customer cancels his request after accepting my offer?
</a>
</h4>
</div>
<div id="collapseSeven" class="panel-collapse collapse">
<div class="panel-body">
No he is not allowed to do so.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseEight">
How do I coordinate with the customer?
</a>
</h4>
</div>
<div id="collapseEight" class="panel-collapse collapse">
<div class="panel-body">
Once customer has accepted your offer, you shall receive the customer details which will include the customer address and contact details, hence you will be able to coordinate with the customer</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseNine">
What do I do once my offer is accepted?
</a>
</h4>
</div>
<div id="collapseNine" class="panel-collapse collapse">
<div class="panel-body">
Once accepted you will see your offer in the successful offers tab. You will now have to process the order and update the delivery status accordingly.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTen">
What if I don’t update the status of the delivery as I process the order? Does if affect any way?
</a>
</h4>
</div>
<div id="collapseTen" class="panel-collapse collapse">
<div class="panel-body">
Yes it does. Customers are notified about the delivery status when you update it. Hence when you do not update the delivery status,the customer will remain unaware about the same.</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseEleven">
What if I do not deliver/ process the order after the customer accepts my offer?

</a>
</h4>
</div>
<div id="collapseEleven" class="panel-collapse collapse">
<div class="panel-body">
You will end up having a bad rating. Each customer will have option to rate the seller, apparently the customer will give you bad ratings.
</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading collapsed">
<h4 class="panel-title">
<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapse12">
What are cancelled offers?
</a>
</h4>
</div>
<div id="collapse12" class="panel-collapse collapse">
<div class="panel-body">
Cancelled offers include the offers rejected by the customer. Also if the customer cancels his request after receiving offers, all the offers for that request are considered as cancelled.
</div>
</div>
</div>
</div>
</div>

    </div>

@endsection