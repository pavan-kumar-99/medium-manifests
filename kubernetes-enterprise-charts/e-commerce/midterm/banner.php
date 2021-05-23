<?php
  $query="SELECT count(IMAGES) as 'counts'  FROM `tblpromopro` pr , `tblproduct` p  
  WHERE pr.`PROID`=p.`PROID` and `PROBANNER`=1";
  $mydb->setQuery($query);
  $cur = $mydb->loadResultList(); 
  foreach ($cur as $result) {
  $maxrow = $result->counts; 
  }
 
?>
 


 
     <header >
     
<img src="banner2.jpg" width="745px" height="250px" >
 
</header>
 
 

    <!-- Script to Activate the Carousel -->
