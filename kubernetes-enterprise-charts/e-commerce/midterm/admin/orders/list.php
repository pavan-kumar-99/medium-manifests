
<div class="container">
	<?php
		 if (!isset($_SESSION['USERID'])){
      redirect(web_root."admin/index.php");
     }

		check_message();
			
		?>

 
 	<div class="row">
       	 <div class="col-lg-12">
            <h1 class="page-header">List of Orders</h1>
       		</div>
        	<!-- /.col-lg-12 -->
   		 </div>
			 
			    <form action="controller.php?action=delete" Method="POST">  					
				 <div class="table-responsive">	
                  <table id="example" class="table  table-striped table-bordered table-hover"  style="font-size:12px" cellspacing="0">
			 		<thead>
			 		<tr >
				  		<th>#</th>
				  		<th>Order#</th>
				  		<th>Customer</th>
				  		<th>DateOrdered</th>	 
				  		<th >Price</th>
				  		<th >PaymentMethod</th>	
				  		<th>Status</th>
				  		<th width="100px">Action</th>
				 
				  	</tr>	
			   		</thead>
			   		<tbody>
					<?php 
				  		$query = "SELECT * FROM `tblsummary` s ,`tblcustomer` c 
				  				WHERE   s.`CUSTOMERID`=c.`CUSTOMERID` ORDER BY   `ORDEREDNUM` desc ";
				  		$mydb->setQuery($query);
				  		$cur = $mydb->loadResultList();

						foreach ($cur as $result) {
						?>

					<?php
						echo '<tr>';
				  		echo '<td width="3%" align="center"></td>';
				  		echo '<td><a href="#" title="View list Of ordered" data-target="#myModal" data-toggle="modal" class="orders" data-id="'.$result->ORDEREDNUM.'">'.$result->ORDEREDNUM .'</a> </td>';  
				  		echo '<td><a href="index.php?view=customerdetails&customerid='.$result->CUSTOMERID.'" title="View customer information">'. $result->FNAME.' '. $result->LNAME.'</a></td>';
				  		echo '<td>'. date_format(date_create($result->ORDEREDDATE),"M/d/Y h:i:s").'</td>';
				  		echo '<td> &#8369 '.number_format($result->PAYMENT ,2).'</td>';
				  		echo '<td >'.$result->PAYMENTMETHOD .'</td>';
				  		// echo '<td></td>';
				  		echo '<td >'. $result->ORDEREDSTATS.'</td>';
				  		echo '<td><a href="controller.php?action=edit&id='.$result->ORDEREDNUM.'&actions=cancel" class="btn btn-danger btn-xs">Cancel</a>
				  				<a href="controller.php?action=edit&id='.$result->ORDEREDNUM.'&actions=confirm"  class="btn btn-primary btn-xs">Confirm</a></td>';
				  		
				  		echo '</tr>';
 
				  	} 
				  	?> 
				 </tbody>
				 	
				</table>
				<div class="btn-group">
				</div>
				</div>
				</form> 

  <div class="modal fade" id="myModal" tabindex="-1">
						
	</div><!-- /.modal -->
