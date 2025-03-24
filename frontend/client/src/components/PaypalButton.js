import { PayPalScriptProvider, PayPalButtons } from "@paypal/react-paypal-js";

const PayPalCheckout = () => {
  const clientId = process.env.REACT_APP_PAYPAL_CLIENT_ID;

  if (!clientId) {
    console.error("PayPal Client ID is missing. Make sure it's set in the .env file.");
    return <p>Error: PayPal Client ID not found.</p>;
  }

  return (
    <PayPalScriptProvider options={{ "client-id": clientId }}>
      <PayPalButtons
        style={{ layout: "vertical" }}
        createOrder={(data, actions) => {
          return actions.order.create({
            purchase_units: [{ amount: { value: "10.00" } }],
          });
        }}
        onApprove={(data, actions) => {
          return actions.order.capture().then((details) => {
            alert(`Transaction completed by ${details.payer.name.given_name}`);
          });
        }}
      />
    </PayPalScriptProvider>
  );
};

export default PayPalCheckout;
