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
