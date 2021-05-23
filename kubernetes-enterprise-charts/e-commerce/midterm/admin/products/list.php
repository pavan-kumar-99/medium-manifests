<?php
		check_message(); 
		?> 
		 
		<div class="row">
       	 <div class="col-lg-12">
            <h1 class="page-header">List of Products  <a href="index.php?view=add" class="btn btn-primary btn-xs  ">  <i class="fa fa-plus-circle fw-fa"></i> New</a>  </h1>
       		</div>
        	<!-- /.col-lg-12 -->
   		 </div>
			    <form action="controller.php?action=delete" Method="POST">  	
			    <div class="table-responsive">				
				<table id="example"  class="table table-striped table-bordered table-hover "  style="font-size:12px" cellspacing="0" >
					
				  <thead>
				  	<tr> 
				  		<th>#</th>
				  		<!--<th>Model</th> -->
				  		 <th align="left"><input type="checkbox" name="chkall" id="chkall" onclick="return checkall('selector[]');"> Model</th>  
				  		<th>Product</th> 
				  		<th>Description</th>
				  		<th>Category</th>
				  		<th>Price</th>
				  		<th>Quantity</th>  
				  		<th width="6%">Action</th> 
				  		 
				  	</tr>	
				  </thead> 	

			  <tbody>
				  	<?php 
				  		$query = "SELECT * FROM `tblproduct` p  ,`tblcategory` c 
				  				WHERE   p.`CATEGID`=c.`CATEGID`";
				  		$mydb->setQuery($query);
				  		$cur = $mydb->loadResultList();

						foreach ($cur as $result) { 
				  		echo '<tr>';
						
				  		echo '<td width="3%" align="center"></td>';
				    		
				  		echo '<td><input type="checkbox" name="selector[]" id="selector[]" value="'.$result->PROID. '"/>
                                  <a title="edit" href="'.web_root.'admin/products/index.php?view=edit&id='.$result->PROID.'">' . $result->PROMODEL.'</a></td>';
				  		echo '<td>'.$result->PRONAME.'</a></td>';
				  		
				  		echo '<td>'. $result->PRODESC.'</td>'; 
				  		echo '<td>'. $result->CATEGORIES.'</td>'; 
				  		echo '<td> &#8369 '.  number_format($result->PROPRICE,2).'</td>';
				  		echo '<td width="4%">'. $result->PROQTY.'</td>'; 
				  		
				  		if ($result->PROSTATS=='Available'){
				  			$stats = 'Available';
				  		}else{
				  			$stats = 'NotAvailable';
				  		}
				  		echo '<td align="left">
				  		<a href="'.web_root.'admin/products/controller.php?action=edit&id='.$result->PROID.'&stats='.$stats.'" class="btn btn-primary btn-xs">'.$stats.'</a></td>';
				  	} 
				  	?>
				  </tbody>
					
				 	
				</table>

				<div class="btn-group">
				
				  <button type="submit" class="btn btn-danger" name="delete"><i class="fa fa-trash fw-fa"></i> Delete Selected</button>
				</div>
				</div>
				</form>
 
 