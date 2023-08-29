using System.Security.Claims;
using System.Security.Cryptography.X509Certificates;

namespace H3_AppProgrammering___Scrum_Board
{
    class MyCertValidation
    {
        public bool ValidateCertificate(X509Certificate2 clientCertificate)
        {
            try
            {
                // Reads the installed client certificates 
                var store = new X509Store(StoreName.Root, StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly);
                var certficate = store.Certificates.OfType<X509Certificate2>().FirstOrDefault(x => x.Thumbprint == clientCertificate.Thumbprint);
                store.Close();
                // Maching certificate will authenticated with its expiry date too
                if (certficate == null)
                {
                    //Logger.LogError("Install the client certificate first. Certificate- Issuer :{0}, Certificate Thumbprint: {1}", clientCertificate.Issuer, clientCertificate.Thumbprint);
                }
                // Check the certificate expry 
                if ((certficate != null) && (clientCertificate.Thumbprint == certficate.Thumbprint) && (System.DateTime.Today <= System.Convert.ToDateTime(certficate.GetExpirationDateString())))
                {
                    if (System.Convert.ToDateTime(certficate.GetExpirationDateString()).AddDays(-30) <= System.DateTime.Today)
                    {
                        //Logger.LogWarning("Certificate is about to expire in {0} days. Issuer :{1}", (System.Convert.ToDateTime(certficate.GetExpirationDateString()) - System.DateTime.Today).Days, certficate.Issuer);
                    }
                    return true;
                }
                return false;
            }
            catch (Exception error)
            {
                //Logger.LogError("Failed to authenticate the cleint certificate {0}", error.Message);
                return false;
            }
        }
    }
}
