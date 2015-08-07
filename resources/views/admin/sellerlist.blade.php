@extends('layouts.master') 
@section('content')
<div class="content">  
       <button type="button" class="btn btn-default btn-cons pull-right"><i class="fa fa-download"></i> Download CSV</button>
		<div class="page-title m-l-5">	
			<h3 class="inline"><span class="semi-bold">Sellers</span> List</h3>
		</div>
		<div class="grid simple vertical purple">
      
			<h4 class="grid-title">List Of Sellers</h4>
			<div class="grid-body">
         <table class="table table-bordered sellerList">
          <thead>
            <tr>
              <th>Seller Name</th>
              <th>Area</th>
              <th>Category</th>
              <th>Avg Response Time</th>
              <th>Response Ratio</th>
              <th>No. of Successfull Offers</th>
              <th>Avg Ratings</th>
              <th>Balance Credits</th>
              <th>Registered Date</th>
              <th>Last Login</th>
            </tr>
          </thead>
          <tbody>
           @foreach($sellers as $seller)
              <tr  onclick="location.href='{{ url('admin/seller/'.$seller['id']) }}'">
                <td>{{ $seller['name'] }}</td>
                <td>{{ $seller['area'] }}</td>
                <td>{{ $seller['categories'] }}</td>
                <td>-</td>
                <td>{{ $seller['offersCount'] }}/-</td>
                <td>{{ $seller['successfullCount'] }}</td>
                <td>-</td>
                <td>-</td>
                <td>{{ $seller['createdAt'] }}</td>
                <td>-</td>
              </tr>
           @endforeach
          </tbody>
         </table>
                        </div>
		</div>
    </div> 
@endsection