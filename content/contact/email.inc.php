<?php

// FUNCTIONS ___________________________________________________________________
function email_emailIsValid($email)
{
	$regexp = 	"/^([a-zA-Z0-9])+([\+\.a-zA-Z0-9_-])*".
					"@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-]+)*\.".
					"([a-zA-Z]{2,6})$/";
	
	return preg_match($regexp, $email);
}

function email_messageIsValid($str)
{
	if(empty($str)) return false;
	$regexp = "/(%0A|%0D|\n+|\r+)(Mime-Version:|content-type:|to:|cc:|bcc:)/i";
	return !preg_match($regexp, $str);
}

function email_formSended($refUid)
{
	return !empty($_POST['uid']) && $_POST['uid'] == $refUid;
}

function email_send($to,$from,$subject,$body)
{
	$headers  = "MIME-Version: 1.0\r\n";
	$headers .= "Content-type: text/html; charset=UTF-8\r\n";
	$body     = "<html><body><p>\n".nl2br($body);
	$body    .= "</p><pre>\n\n\n------------------------------------------\n";
	$body    .= "Message envoyé depuis sofa-design.net par $from</pre>";
	$body    .= "</body></html>";
	if(function_exists("email")){
		// pour online.net
		$replyTo = $from;
		return email("webmaster", $to, $subject, $body, $replyTo, $headers);
	} else {
		$headers .= "From: $from\r\n";
		$headers  .= "Return-Path: ".$to."\n";
		return mail($to, $subject, $body, $headers);
	}
}

function email_cleanFormVars()
{
	foreach($_POST as $k=>$v)
	{
		$_POST[$k] = trim(stripslashes($v));
	}	
}

// CONTROLLER __________________________________________________________________

email_cleanFormVars();
// init vars
if(!isset($_POST['email']))   $_POST['email']   = '';
if(!isset($_POST['message'])) $_POST['message'] = '';
$email_to         = "studio+website2@sofa-design.net";
$email_subject    = "sofa-design.net - envoyé par ".$_POST['email'];
$email_successUrl = "/contact/?ok#nouscontacter";

// init form vars
$f = array();
$f['uid']              = "My_Deer_A27556D89593-81A5865C-2598-11DC-B239";
$f['email_is_spam']    = true;
$f['email_is_valid']   = true;
$f['message_is_valid'] = true;
$f['email_value']      = $_POST['email'];
$f['message_value']    = $_POST['message'];
$f['flash']            = isset($_GET['ok']);


if(email_formSended($f['uid']))
{
	$f['email_is_spam']    = !empty($_POST['captcha']) ||
	                         !empty($_POST['comment']);
	                         
	if($f['email_is_spam']) die();
	
	$f['email_is_valid']   = email_emailIsValid($_POST['email']);
	$f['message_is_valid'] = email_messageIsValid($_POST['message']);
	
	if($f['email_is_valid'] && $f['message_is_valid'])
	{
		$email_success = email_send(	$email_to,
												          $_POST['email'],
												          $email_subject,
												          $_POST['message']	);
		if($email_success)
		{
			header('Location: '.$email_successUrl);
			exit;
		}
	}
}

?>