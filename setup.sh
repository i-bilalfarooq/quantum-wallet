#!/bin/bash

# Quantum-Secure Wallet Setup Script
echo "=========================================="
echo "Setting up Quantum-Secure Wallet with AI"
echo "=========================================="

# Create project structure
echo "Creating project structure..."
mkdir -p quantum-wallet
cd quantum-wallet
mkdir -p crypto wallet ai-service

# Initialize Go module
echo "Initializing Go module..."
go mod init quantum-wallet

# Create required files
echo "Creating source files..."

# Create crypto directory files
cat > crypto/kyber.go << 'EOL'
// crypto/kyber.go
package crypto

// KyberKeyPair represents a quantum-resistant key encapsulation key pair
type KyberKeyPair struct {
	PublicKey  []byte
	PrivateKey []byte
}

// DilithiumKeyPair represents a quantum-resistant signature key pair
type DilithiumKeyPair struct {
	PublicKey  []byte
	PrivateKey []byte
}
EOL

cat > crypto/crypto_manager.go << 'EOL'
// crypto/crypto_manager.go
package crypto

import (
	"crypto/rand"
	"errors"
	"log"
)

// Security levels for quantum-resistant algorithms
type KyberSecurityLevel int
type DilithiumSecurityLevel int

const (
	KyberLevel512 KyberSecurityLevel = iota
	KyberLevel768
	KyberLevel1024 // Highest security
)

const (
	DilithiumLevel2 DilithiumSecurityLevel = iota
	DilithiumLevel3
	DilithiumLevel5 // Highest security
)

// CryptoManager handles all cryptographic operations
type CryptoManager struct {
	kyberLevel    KyberSecurityLevel
	dilithiumLevel DilithiumSecurityLevel
	logger        *log.Logger
}

// NewCryptoManager creates a new cryptographic manager with the specified security levels
func NewCryptoManager(kyberLevel KyberSecurityLevel, dilithiumLevel DilithiumSecurityLevel, logger *log.Logger) (*CryptoManager, error) {
	if logger == nil {
		return nil, errors.New("logger cannot be nil")
	}
	
	return &CryptoManager{
		kyberLevel:    kyberLevel,
		dilithiumLevel: dilithiumLevel,
		logger:        logger,
	}, nil
}

// GenerateKEMKeyPair generates a new Kyber key pair for key encapsulation
func (cm *CryptoManager) GenerateKEMKeyPair() (*KyberKeyPair, error) {
	// Size depends on security level
	var publicKeySize, privateKeySize int
	
	switch cm.kyberLevel {
	case KyberLevel512:
		publicKeySize = 800
		privateKeySize = 1632
	case KyberLevel768:
		publicKeySize = 1184
		privateKeySize = 2400
	case KyberLevel1024:
		publicKeySize = 1568
		privateKeySize = 3168
	}
	
	publicKey := make([]byte, publicKeySize)
	privateKey := make([]byte, privateKeySize)
	
	// Generate random keys (in a real implementation, these would be proper Kyber keys)
	_, err := rand.Read(publicKey)
	if err != nil {
		return nil, err
	}
	
	_, err = rand.Read(privateKey)
	if err != nil {
		return nil, err
	}
	
	cm.logger.Printf("Generated Kyber key pair at security level %v", cm.kyberLevel)
	
	return &KyberKeyPair{
		PublicKey:  publicKey,
		PrivateKey: privateKey,
	}, nil
}

// GenerateSignatureKeyPair generates a new Dilithium key pair for signatures
func (cm *CryptoManager) GenerateSignatureKeyPair() (*DilithiumKeyPair, error) {
	// Size depends on security level
	var publicKeySize, privateKeySize int
	
	switch cm.dilithiumLevel {
	case DilithiumLevel2:
		publicKeySize = 1312
		privateKeySize = 2528
	case DilithiumLevel3:
		publicKeySize = 1952
		privateKeySize = 4000
	case DilithiumLevel5:
		publicKeySize = 2592
		privateKeySize = 4864
	}
	
	publicKey := make([]byte, publicKeySize)
	privateKey := make([]byte, privateKeySize)
	
	// Generate random keys (in a real implementation, these would be proper Dilithium keys)
	_, err := rand.Read(publicKey)
	if err != nil {
		return nil, err
	}
	
	_, err = rand.Read(privateKey)
	if err != nil {
		return nil, err
	}
	
	cm.logger.Printf("Generated Dilithium key pair at security level %v", cm.dilithiumLevel)
	
	return &DilithiumKeyPair{
		PublicKey:  publicKey,
		PrivateKey: privateKey,
	}, nil
}

// CombinedEncryptAndSign encrypts data using Kyber and signs it with Dilithium
func (cm *CryptoManager) CombinedEncryptAndSign(recipientPublicKey []byte, senderKeypair *DilithiumKeyPair, data []byte) ([]byte, []byte, []byte, error) {
	// In a real implementation, this would use actual Kyber encryption
	ciphertext := make([]byte, len(data)+32) // Additional bytes for entropy
	_, err := rand.Read(ciphertext[:32])
	if err != nil {
		return nil, nil, nil, err
	}
	
	// Simple XOR encryption for simulation
	for i := 0; i < len(data); i++ {
		ciphertext[i+32] = data[i] ^ ciphertext[i%32]
	}
	
	// Generate shared encryption key (would be proper shared secret in real implementation)
	encKey := make([]byte, 32)
	for i := 0; i < 32; i++ {
		if i < len(recipientPublicKey) {
			encKey[i] = recipientPublicKey[i] ^ senderKeypair.PrivateKey[i%len(senderKeypair.PrivateKey)]
		}
	}
	
	// Simulate signing the data (would be proper Dilithium signature in real implementation)
	signature := make([]byte, 2048)
	_, err = rand.Read(signature[:16])
	if err != nil {
		return nil, nil, nil, err
	}
	
	// Add some determinism to the signature based on the private key and data
	for i := 16; i < len(signature); i++ {
		hashByte := byte(i % 256)
		for j := 0; j < len(data); j++ {
			hashByte ^= data[j]
		}
		
		privKeyIdx := i % len(senderKeypair.PrivateKey)
		signature[i] = senderKeypair.PrivateKey[privKeyIdx] ^ hashByte
	}
	
	return ciphertext[:32], ciphertext[32:], signature, nil
}

// RotateKeys rotates both Kyber and Dilithium keys (stub implementation)
func (cm *CryptoManager) RotateKeys() error {
	// In a real implementation, this would involve more complex key rotation protocols
	cm.logger.Println("Keys rotated successfully")
	return nil
}
EOL

# Create wallet implementation
cat > wallet/ai_client.go << 'EOL'
// wallet/ai_client.go
package wallet

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

// AIClient handles communication with the AI service
type AIClient struct {
	BaseURL string
}

// NewAIClient creates a new AI client
func NewAIClient(baseURL string) *AIClient {
	return &AIClient{BaseURL: baseURL}
}

// PredictionRequest contains features for anomaly detection
type PredictionRequest struct {
	Amount    float64 `json:"amount"`
	TimeDiff  float64 `json:"time_diff"`
	TxCount   int     `json:"tx_count"`
}

// PredictionResponse contains the AI model's assessment
type PredictionResponse struct {
	IsAnomaly  bool    `json:"is_anomaly"`
	Confidence float64 `json:"confidence"`
}

// PredictAnomaly sends transaction data to the AI model for analysis
func (c *AIClient) PredictAnomaly(req PredictionRequest) (bool, float64, error) {
	body, err := json.Marshal(req)
	if err != nil {
		return false, 0.0, err
	}
	
	resp, err := http.Post(c.BaseURL+"/predict", "application/json", bytes.NewBuffer(body))
	if err != nil {
		return false, 0.0, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return false, 0.0, fmt.Errorf("AI service returned status: %s", resp.Status)
	}

	var result PredictionResponse
	err = json.NewDecoder(resp.Body).Decode(&result)
	return result.IsAnomaly, result.Confidence, err
}
EOL

cat > wallet/wallet.go << 'EOL'
// wallet/wallet.go
package wallet

import (
	"fmt"
	"quantum-wallet/crypto"
	"time"
)

type QuantumWallet struct {
	Crypto        *crypto.CryptoManager
	KyberKP       *crypto.KyberKeyPair
	DilithiumKP   *crypto.DilithiumKeyPair
	Transactions  []string
	TxHistory     []time.Time
	LastRotation  time.Time
	AIClient      *AIClient
}

// CreateWallet creates a new quantum-secure wallet
func CreateWallet(cm *crypto.CryptoManager) (*QuantumWallet, error) {
	// Generate quantum-safe keys
	kyberKP, err := cm.GenerateKEMKeyPair()
	if err != nil {
		return nil, err
	}

	dilKP, err := cm.GenerateSignatureKeyPair()
	if err != nil {
		return nil, err
	}

	return &QuantumWallet{
		Crypto:        cm,
		KyberKP:       kyberKP,
		DilithiumKP:   dilKP,
		LastRotation:  time.Now(),
		TxHistory:     []time.Time{time.Now()}, // Initialize with current time
	}, nil
}

// CreateWalletWithAI creates a wallet with AI security features
func CreateWalletWithAI(cm *crypto.CryptoManager, aiEndpoint string) (*QuantumWallet, error) {
	wallet, err := CreateWallet(cm)
	if err != nil {
		return nil, err
	}
	
	wallet.AIClient = NewAIClient(aiEndpoint)
	return wallet, nil
}

// SendTransaction executes a quantum-secure transaction
func (w *QuantumWallet) SendTransaction(recipient string, amount float64) ([]byte, error) {
	// Create transaction payload
	txData := fmt.Sprintf("%s:%f:%d", recipient, amount, time.Now().Unix())
	
	// Quantum-safe encryption and signing
	ct, encData, sig, err := w.Crypto.CombinedEncryptAndSign(
		w.KyberKP.PublicKey,
		w.DilithiumKP,
		[]byte(txData),
	)
	
	if err != nil {
		return nil, err
	}

	// Store transaction in history
	w.Transactions = append(w.Transactions, txData)
	w.TxHistory = append(w.TxHistory, time.Now())

	// Return full transaction package
	return append(append(ct, encData...), sig...), nil
}

// SendTransactionWithAI performs a transaction with AI security checks
func (w *QuantumWallet) SendTransactionWithAI(recipient string, amount float64) error {
	// Ensure we have transaction history
	if len(w.TxHistory) == 0 {
		w.TxHistory = append(w.TxHistory, time.Now())
	}

	// Calculate transaction features
	timeDiff := 0.0
	if len(w.TxHistory) > 0 {
		timeDiff = time.Since(w.TxHistory[len(w.TxHistory)-1]).Hours()
	}

	features := PredictionRequest{
		Amount:    amount,
		TimeDiff:  timeDiff,
		TxCount:   len(w.TxHistory),
	}

	// Check with AI
	isAnomaly, confidence, err := w.AIClient.PredictAnomaly(features)
	if err != nil {
		return err
	}

	if isAnomaly {
		w.RotateKeys()
		return fmt.Errorf("quantum attack suspected (confidence: %.2f)", confidence)
	}

	// Proceed with normal transaction
	_, err = w.SendTransaction(recipient, amount)
	return err
}

// RotateKeys performs quantum-safe key rotation
func (w *QuantumWallet) RotateKeys() error {
	newKyber, err := w.Crypto.GenerateKEMKeyPair()
	if err != nil {
		return err
	}

	newDilithium, err := w.Crypto.GenerateSignatureKeyPair()
	if err != nil {
		return err
	}

	// Add re-encryption logic here
	w.KyberKP = newKyber
	w.DilithiumKP = newDilithium
	w.LastRotation = time.Now()
	
	// Reset transaction history after rotation
	w.TxHistory = []time.Time{time.Now()}
	
	return nil
}
EOL

# Create main.go
cat > main.go << 'EOL'
// main.go
package main

import (
	"quantum-wallet/crypto"
	"quantum-wallet/wallet"
	"log"
	"time"
	"os"
	"fmt"
)

func main() {
	// Configure logger
	logger := log.New(os.Stdout, "[QUANTUM-WALLET] ", log.LstdFlags)

	// Initialize crypto
	logger.Println("Initializing cryptography manager...")
	cm, err := crypto.NewCryptoManager(
		crypto.KyberLevel1024, 
		crypto.DilithiumLevel3,
		logger,
	)
	if err != nil {
		logger.Fatal("Crypto initialization failed:", err)
	}

	// Create AI-enhanced wallet
	logger.Println("Creating quantum-secure wallet with AI protection...")
	qw, err := wallet.CreateWalletWithAI(cm, "http://localhost:5000")
	if err != nil {
		logger.Fatal("Wallet creation failed:", err)
	}

	// Display wallet information
	fmt.Println("\n=== QUANTUM-SECURE WALLET CREATED ===")
	fmt.Printf("Kyber Public Key: %x...\n", qw.KyberKP.PublicKey[:16])
	fmt.Printf("Dilithium Public Key: %x...\n", qw.DilithiumKP.PublicKey[:16])
	fmt.Println("Creation Time:", qw.LastRotation)
	fmt.Println("======================================\n")

	// Test normal transaction
	logger.Println("Testing normal transaction...")
	txID, err := qw.SendTransaction("diam1q2w3e4r5t6y7u8i9o0p", 0.5)
	if err != nil {
		logger.Fatal("Transaction failed:", err)
	}
	logger.Printf("Transaction successful! TX ID: %x...\n", txID[:16])
	
	// Sleep for a moment
	time.Sleep(1 * time.Second)

	// Test with AI security
	fmt.Println("\n=== TESTING AI SECURITY FEATURES ===")
	
	// Test normal transaction with AI
	fmt.Println("\nAttempting normal transaction with AI security...")
	err = qw.SendTransactionWithAI("diam1q2w3e4r5t6y7u8i9o0p", 1.5)
	if err != nil {
		fmt.Println("Transaction blocked:", err)
	} else {
		fmt.Println("Transaction completed successfully")
	}

	// Test anomalous transaction with AI
	fmt.Println("\nAttempting suspicious transaction with AI security...")
	err = qw.SendTransactionWithAI("diam9z8x7c6v5b4n3m2l1k", 10000)
	if err != nil {
		fmt.Println("Transaction blocked:", err)
		fmt.Printf("Keys automatically rotated. New Kyber public key: %x...\n", qw.KyberKP.PublicKey[:16])
	} else {
		fmt.Println("Transaction completed successfully")
	}
	
	fmt.Println("\n=== AI SECURITY DEMONSTRATION COMPLETE ===")
}
EOL

# Create AI service files
mkdir -p ai-service
cat > ai-service/model.py << 'EOL'
# ai-service/model.py
import joblib
import numpy as np
from sklearn.ensemble import IsolationForest

def train_model():
    print("Training anomaly detection model...")
    
    # Generate training data (normal transactions)
    np.random.seed(42)
    
    # Normal transactions: [amount, time_diff, tx_count]
    normal_data = np.vstack([
        # Small amounts, varying time gaps, low tx counts
        np.random.uniform(low=0.1, high=5, size=(800, 1)),
        np.random.uniform(low=0.5, high=48, size=(800, 1)),
        np.random.randint(1, 20, size=(800, 1))
    ]).T
    
    # Anomalous data patterns
    anomalies = np.vstack([
        # Large amounts
        np.vstack([
            np.random.uniform(low=1000, high=50000, size=(50, 1)),
            np.random.uniform(low=0.5, high=48, size=(50, 1)),
            np.random.randint(1, 20, size=(50, 1))
        ]).T,
        
        # Very frequent transactions (small time gaps)
        np.vstack([
            np.random.uniform(low=0.1, high=5, size=(50, 1)),
            np.random.uniform(low=0.01, high=0.1, size=(50, 1)),
            np.random.randint(50, 200, size=(50, 1))
        ]).T,
        
        # Unusual combinations
        np.vstack([
            np.random.uniform(low=100, high=1000, size=(50, 1)),
            np.random.uniform(low=0.01, high=0.1, size=(50, 1)),
            np.random.randint(1, 5, size=(50, 1))
        ]).T
    ])
    
    # Combine normal and anomalous data for training
    X_train = np.vstack([normal_data, anomalies])
    
    # Train model with contamination level
    model = IsolationForest(contamination=0.1, random_state=42)
    model.fit(X_train)
    
    # Save model
    joblib.dump(model, 'anomaly_model.joblib')
    print("Model trained and saved to 'anomaly_model.joblib'")
    
    # Test the model
    test_cases = [
        # Normal cases
        [2.5, 12.0, 5],    # Normal amount, normal time gap, normal count
        [0.8, 24.0, 10],   # Small amount, normal time gap, normal count
        
        # Anomalous cases
        [15000, 1.0, 3],   # Very large amount
        [3.0, 0.05, 100],  # Very frequent transactions
        [500, 0.03, 2]     # Medium amount with suspicious pattern
    ]
    
    print("\nModel testing with sample cases:")
    for case in test_cases:
        features = np.array(case).reshape(1, -1)
        prediction = model.predict(features)
        confidence = abs(model.score_samples(features)[0])
        status = "ANOMALY" if prediction[0] == -1 else "NORMAL"
        print(f"Case {case}: {status} (confidence: {confidence:.2f})")

if __name__ == "__main__":
    train_model()
EOL

cat > ai-service/app.py << 'EOL'
# ai-service/app.py
from flask import Flask, jsonify, request
import joblib
import numpy as np
import os

app = Flask(__name__)

# Check if model exists, create it if not
MODEL_PATH = 'anomaly_model.joblib'
if not os.path.exists(MODEL_PATH):
    from model import train_model
    train_model()

# Load model
try:
    model = joblib.load(MODEL_PATH)
    print(f"Model loaded successfully from {MODEL_PATH}")
except Exception as e:
    print(f"Error loading model: {e}")
    print("Creating a new model...")
    from model import train_model
    train_model()
    model = joblib.load(MODEL_PATH)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    
    try:
        # Extract features
        features = np.array([
            data['amount'],
            data['time_diff'],
            data['tx_count']
        ]).reshape(1, -1)
        
        # Make prediction
        prediction = model.predict(features)
        confidence = abs(model.score_samples(features)[0])
        
        # Log the prediction
        status = "ANOMALY" if prediction[0] == -1 else "NORMAL"
        print(f"Prediction: {status}, Confidence: {confidence:.2f}, Features: {features.flatten()}")
        
        return jsonify({
            'is_anomaly': bool(prediction[0] == -1),
            'confidence': float(confidence)
        })
    
    except Exception as e:
        print(f"Error processing request: {e}")
        return jsonify({
            'error': str(e)
        }), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    print("Starting AI anomaly detection service on port 5000...")
    app.run(host='0.0.0.0', port=5000)
EOL

cat > ai-service/requirements.txt << 'EOL'
flask==2.0.1
scikit-learn==1.0.2
numpy==1.22.3
pandas==1.4.2
joblib==1.1.0
EOL

# Create run scripts
cat > run.sh << 'EOL'
#!/bin/bash

# Build and run the Quantum-Secure Wallet

# Start AI service in background
echo "Starting AI anomaly detection service..."
cd ai-service
python app.py &
AI_PID=$!

# Wait for AI service to start
echo "Waiting for AI service to initialize..."
sleep 5

# Return to main directory
cd ..

# Run the wallet application
echo "Running quantum wallet application..."
go run main.go

# Cleanup
echo "Cleaning up..."
kill $AI_PID
EOL

# Make scripts executable
chmod +x run.sh

echo "=========================================="
echo "Setup complete!"
echo "To run the quantum wallet:"
echo "  cd quantum-wallet"
echo "  ./run.sh"
echo "=========================================="
