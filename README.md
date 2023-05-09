# CA_cert_generator_with_sans
Bash script to generate a self signed rootCA with SANS for software that requires SANS and can't use letsencrypt for some reason.
Confirmed working on ubuntu, including any* ubuntu 20.04 or later based distro.
Does not (yet) work on rhel based linux distro's.
Not confirmed woring on arch based distro's

* i have not yet found a debian based distro on which it does not work

the newcerts script is currently a wip and will replace the old certs script as soon as it is ready to go.
it is also an effort to make this script work on rhel based linux distro's.
The old script (genCwithsans) will not be removed after the new script is ready. (for reference purposes)
