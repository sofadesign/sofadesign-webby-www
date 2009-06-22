---
title:      Index
created_at: 2009-03-24 14:44:49.112271 +01:00
extension:  php
filter:
  - erb
---
<h1>Contact</h1>

<div id="coordonnees" class="section">	
  <h2>Coordonnées</h2>

  <address>			
    <p>Sofa Design<br>                
    	6 square du roi Arthur<br>                
    	35000 RENNES</p>
    
    <p>tél.: +33 (0)2 23 42 15 61</p>
	</address>
</div>

<div id="nouscontacter" class="section">
	<h2>Me contacter</h2>
<?php include 'email.inc.php'; ?>	
<?php if($f['flash']): ?>
	<div class="flash success">	
	<p>Votre message a bien été envoyé.</p>
	</div>
<?php endif; ?>

	<form action="/contact/#nouscontacter" method="post">
	<fieldset>
	  <input type="hidden" id="uid" name="uid" value=<?php echo $f['uid'];?>>
		<p><label>Votre adresse e-mail:<br>
			<input type="text" id="email" name="email" tabindex="110" value=<?php echo $f['email_value']?>></label></p>
		
		<script type="text/javascript">
		  document.getElementById('email').focus();
		</script>
		
<?php if(!$f['email_is_valid']): ?>
		<p class="alert">Adresse e-mail incorrecte.</p>
		<script type="text/javascript">
		  document.getElementById('email').focus();
		</script>
<?php endif; ?>

		<p><label>Votre message:<br>
		<textarea id="message" name="message" rows="10" cols="30" tabindex="120"><?=$f['message_value']?></textarea></label></p>

<?php if(!$f['message_is_valid']): ?>
		<p class="alert">Veuillez saisir votre message.</p>
		<script type="text/javascript">
		  document.getElementById('message').focus();
		</script>
<?php endif; ?>

		<p class="noseeum" style="display:none;visibility:hidden;">
			Ne rien saisir dans le champ qui suit (à moins que vous ne soyez
			un vilain robot):<br>
			<input type="text" id="captcha" name="captcha" maxlength="50">
			<br><br>
			Ne rien saisir dans ce champs non plus:<br>
			<textarea name="comment" rows="6" cols="60"></textarea>
		</p>
		<p><input type="submit" id="envoyer" name="envoyer" value="Envoyer" class="bt_envoyer" tabindex="130">
		</p>
	</fieldset>
	</form>

</div>
