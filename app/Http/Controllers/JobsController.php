<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Admin\AttributeController;
use Parse\ParseObject;
use Parse\ParseQuery;

class JobsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $sellerQuery = new ParseQuery("_User");
        $sellerQuery->equalTo("userType", "seller");
        $sellerQuery->exists("autoBid");
        $sellerQuery->equalTo("autoBid", true);

        $autoBidSellers = $sellerQuery->find();

        // dd( $autoBidSellers );
        
        foreach ($autoBidSellers as $autoBidSeller) {
            /** get requests that are:
                1. status = open
                2. createdAt is less than or equal to currentDate10MinutesAgo 
            **/
            $sellerId = $autoBidSeller->getObjectId();
            $openRequestsForSeller = $this->getNewOpenRequests($sellerId);

            $openBidRequests = $this->getAutoBiddableRequests($openRequestsForSeller);

            foreach ($openBidRequests as $openRequest) {
                $lastOfferPrice = $openRequest["lastOfferPrice"];
                $lastOfferPrice = $openRequest["lastDeliveryTime"];
            }
        }

    // currentDate = new Date()
    // currentTimeStamp = currentDate.getTime()
    // expiryValueInHrs = 24
    // queryDate = new Date()
    // time24HoursAgo = currentTimeStamp - (expiryValueInHrs * 60 * 60 * 1000)
    // queryDate.setTime(time24HoursAgo) 
    //     queryRequest.lessThanOrEqualTo( "createdAt", queryDate )                
    //     }

    }
    public function getNewOpenRequests($sellerId){
        $newOpenRequestsData = array (
            "sellerId" => $sellerId,
            "city" =>  "default",
            "area" =>  "default",
            "sellerLocation" =>  "default",
            "sellerRadius" => "default",
            "categories"  =>  "default",
            "brands" =>  "default",
            "productMrp" =>  "default"
        );


        $functionName = "getNewRequests";

        $resultjson = AttributeController::makeParseCurlRequest($functionName,$newOpenRequestsData); 

        $response =  json_encode($resultjson);
        $response = json_decode($response,true); 

        return $response["result"]["requests"];

    }

    public function getAutoBiddableRequests($openRequests){

        $biddableRequests = [];        

        foreach ($openRequests as $openRequest) {
            
            echo "<pre>";
            // current date in utc
            $current_date_utc = new \DateTime(null, new \DateTimeZone("UTC"));
            echo "<br/>";
            print_r($current_date_utc->format('d-m-Y h:i:s'));
            echo "<br/>";

            $requestcreatedAt = $openRequest['createdAt'];

            $requestCreatedDateObject = new \DateTime($requestcreatedAt['iso']);

            // print_r($requestCreatedDateObject);
            
            // add 10 minutes to request created date
            $mins10 = 10*60 ;
            // $createdPlus10Mins = $requestCreatedDateObject->add(new \DateInterval('PT'.$mins10.'S'));
            // $createdPlus10Mins = $requestCreatedDateObject->add(new \DateInterval('PT'.$mins10.'S'));
            print_r($requestCreatedDateObject->format('d-m-Y h:i:s'));echo "<br/>";
            print_r($openRequest["id"]);
            // check difference in minutes between current date and request created date object 
            $interval = $current_date_utc->diff($requestCreatedDateObject);

            $minutes = $interval->days * 24 * 60;
            $minutes += $interval->h * 60;
            $minutes += $interval->i;
            echo "<br/>";
            echo $minutes.' minutes';
            echo "</pre>";

            // if the difference is more than or equal to 10minutes then add this request to array of biddableRequests
            $minutes10 = 10;
            if ($minutes>=$minutes10) {
                $biddableRequests[] = $openRequest;
            }
        }

        return $biddableRequests;
    }
}