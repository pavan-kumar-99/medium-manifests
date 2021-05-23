 <?php
  $customer = New customer;
  $res = $customer->single_customer($_SESSION['CUSID']);
 
  ?>  
<h3>Your Account</h3>
  <form  class="form-horizontal span6" action="customer/controller.php?action=edit" onsubmit="return personalInfo();" name="personal" method="POST" enctype="multipart/form-data">
          <div class="col-lg-12" style="margin-top:5%;">
          <div class="row">
             <div class="col-lg-6">
            <div class="form-group">
              <div class="col-md-12">
                <label class="col-md-4 control-label" for=
                "FNAME">First Name:</label>
                  <div class="col-md-8">
                   <input class="form-control input-sm" id="FNAME" name="FNAME" placeholder=
                      "First Name" type="text" value="<?php echo $res->FNAME; ?>">
                </div>
              </div>
            </div>
           </div>   
           
           <div class="col-lg-6"> 
            <div class="form-group">
              <div class="col-md-12">
                <label class="col-md-4 control-label" for=
                "LNAME">Last Name:</label>

                <div class="col-md-8">
                   <input class="form-control input-sm" id="LNAME" name="LNAME" placeholder=
                      "Last Name" type="text" value="<?php echo $res->LNAME; ?>">
                </div>
              </div>
            </div>
           </div>   

           <div class="col-lg-6">
             <div class="form-group">
                <div class="col-md-12">
                  <label class="col-md-4 control-label" for=
                  "CUSHOMENUM">Home#:</label>

                  <div class="col-md-8">
                     <input class="form-control input-sm" id="CUSHOMENUM" name="CUSHOMENUM" placeholder=
                        "Home Number" type="text" value="<?php echo $res->CUSHOMENUM; ?>">
                  </div>
                </div>
              </div>
           </div>  
            <div class="col-lg-6">
   
               <div class="form-group">
                <div class="col-md-12">
                  <label class="col-md-4 control-label" for=
                  "STREETADD">STREET/Village:</label>

                  <div class="col-md-8">
                     <input class="form-control input-sm" id="STREETADD" name="STREETADD" placeholder=
                        "STREET / Village" type="text" value="<?php echo $res->STREETADD; ?>">
                  </div>
                </div>
              </div>
           </div>  

            <div class="col-lg-6">
              <div class="form-group">
                <div class="col-md-12"> 
                  <label class="col-md-4 control-label" for=
                  "BRGYADD">Barangay:</label>

                  <div class="col-md-8">
                     <input class="form-control input-sm" id="BRGYADD" name="BRGYADD" placeholder=
                        "Barangay" type="text" value="<?php echo $res->BRGYADD; ?>">
                  </div>
                </div>
              </div> 
           </div>  
            <div class="col-lg-6">
             
             <div class="form-group">
              <div class="col-md-12">
                <label class="col-md-4 control-label" for=
                "CITYADD">Municipality/City:</label>

                <div class="col-md-8">
                   <input class="form-control input-sm" id="CITYADD" name="CITYADD" placeholder=
                      "Municipality/City Address" type="text" value="<?php echo $res->CITYADD; ?>">
                </div>
              </div>
            </div>

           </div>  


            <div class="col-lg-6">
             <div class="form-group">
              <div class="col-md-12">
                <label class="col-md-4 control-label" for=
                "PROVINCE">Province:</label>

                <div class="col-md-8">
                   <input class="form-control input-sm" id="PROVINCE" name="PROVINCE" placeholder=
                      "Province" type="text" value="<?php echo $res->PROVINCE; ?>">
                </div>
              </div>
            </div>
           </div>  
            <div class="col-lg-6"> 
              <div class="form-group">
              <div class="col-md-12">
                <label class="col-md-4 control-label" for=
                "COUNTRY">Country:</label>

                <div class="col-md-8">
                   <input class="form-control input-sm" id="COUNTRY" name="COUNTRY" placeholder=
                      "Country" type="text" value="<?php echo $res->COUNTRY; ?>">
                </div>
              </div>
            </div>
           </div>   
             
            <div class="col-lg-6">
              <div class="form-group">
                <div class="col-md-12">
                  <label class="col-md-4 control-label" for=
                  "CUSUNAME">Username:</label>

                  <div class="col-md-8">
                     <input class="form-control input-sm" id="CUSUNAME" name="CUSUNAME" placeholder=
                        "Username" type="text" value="<?php echo $res->CUSUNAME; ?>">
                  </div>
                </div>
              </div> 
           </div>  
            <div class="col-lg-6">
               <div class="form-group">
                  <div class="col-md-12">
                    <label class="col-md-4 control-label" for=
                    "CUSPASS">Password:</label>

                    <div class="col-md-8">
                       <input class="form-control input-sm" id="CUSPASS" name="CUSPASS" placeholder=
                          "Password" type="password" value="<?php echo  sha1($res->CUSPASS); ?>"><span></span>
                          <!--  <p>Note</p>
                          Password must be atleast 8 to 15 characters. Only letter, numeric digits, underscore and first character must be a letter.
                       -->
                    </div>
                  </div>
                </div>
           </div>

            <div class="col-lg-6">
              <div class="form-group">
                      <div class="col-md-12">
                        <label class="col-md-4 control-label" for=
                        "GENDER">Gender:</label>

                        <div class="col-lg-8">
                          <input  id="GENDER" name="GENDER" placeholder=
                              "Gender" type="radio" <?php echo ($res->GENDER=='Male') ? 'CHECKED' : '' ;  ?>   value="Male"><b> Male </b>
                              <input   id="GENDER"   name="GENDER" placeholder=
                              "Gender" type="radio" <?php echo ($res->GENDER=='Female') ? 'CHECKED' : '' ; ?> value="Female"> <b> Female </b>
                        </div>
                      </div>
                    </div>
           </div>  
            <div class="col-lg-6">
             
                <div class="form-group">
                <div class="col-md-12">
                  <label class="col-md-4 control-label" for=
                  "PHONE">Contact#:</label>

                  <div class="col-md-8">
                     <input class="form-control input-sm" id="PHONE" name="PHONE" placeholder=
                        "Contact Number" type="text" value="<?php echo $res->PHONE; ?>">
                  </div>
                </div>
              </div>

           </div> 



          <div class="col-lg-6">
            <div class="form-group">
                  <div class="col-md-12">
                    <label class="col-md-4 control-label" for=
                    "ZIPCODE">Zip Code:</label>

                    <div class="col-md-8">
                       <input class="form-control input-sm" id="ZIPCODE" name="ZIPCODE" placeholder=
                          "Zip Code" type="number" value="<?php echo $res->ZIPCODE; ?>">
                    </div>
                  </div>
                </div>
           </div>
           </div>  
          </div>
          
           

          <div class="col-lg-6"> 
              <div class="form-group">
                <div class="col-md-12">
                   <label class="col-md-4" align = "right"for=
                  "btn"></label>
                  <div class="col-md-8">
                    <input type="submit"  name="save"  value="Save"  class="submit btn btn-primary btn-lg"  />
                      
                </div>
              </div>
            </div>
         </div>     
  </form>   
  
   
                
 
                  

                               
                





 
              








                   
        
        </form>