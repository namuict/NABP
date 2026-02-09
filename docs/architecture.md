# NABP Architecture

## 1. Overview

**NABP (NamuICT Automated Baremetal Provisioning)** 는  
초고성능컴퓨팅(HPC) 및 대규모 데이터센터 환경에서  
수십~수천 대의 베어메탈 서버를 자동으로 설치·운영하기 위한  
**Zero Touch Provisioning (ZTP)** 기반 프로비저닝 자동화 소프트웨어입니다.

NABP는 다음과 같은 환경을 전제로 설계되었습니다.

- 대규모 노드 동시 OS 배포
- Diskfull / Diskless 서버 혼합 구성
- 폐쇄망(Closed Network) 또는 제한된 외부 네트워크
- PXE, DHCP, BMC(IPMI/Redfish), BIOS, OS 설치 자동화
- 배포 단계별 상태 및 체크포인트 수집 및 분석

---

## 2. Architectural Principles

NABP 아키텍처는 다음 원칙을 기반으로 설계되었습니다.

1. Template-Driven Design  
   모든 배포 로직은 Template으로 정의되며 재사용 가능해야 합니다.

2. Workflow-Oriented Execution  
   OS 배포는 고정된 스크립트가 아닌 Workflow 조합으로 수행됩니다.

3. Loose Coupling  
   UI, Control Plane, Provisioning Infrastructure, Target Node는 느슨하게 결합됩니다.

4. Scalability First  
   수백~수천 노드 동시 배포를 고려한 비동기 구조를 채택합니다.

---

## 3. High-Level Architecture

NABP는 크게 다음 3계층 구조로 구성됩니다.

[Web UI Layer]
- Admin UI (Configuration)
- Operator UI (ZTP / Monitoring)

[Control Plane]
- API Server
- Workflow / Template Engine
- ZTP Orchestrator
- State & Checkpoint Manager
- Database

[Provisioning Infrastructure]
- DHCP Proxy (Kea)
- TFTP / HTTP (PXE, Media Path)
- Proxy / Worker Nodes

[Target Baremetal Nodes]
- BMC (IPMI / Redfish)
- PXE Boot
- OS Installer (Diskfull / Diskless)

---

## 4. Core Components

### 4.1 Web UI

Web UI는 NABP의 단일 사용자 진입점입니다.

- Administrator (Configuration)
  - Subnets
  - Installation Media
  - Partition Tables
  - Provisioning Workflow
  - Operating Systems
  - Machine Groups

- Operator (Operation)
  - ZTP Templates
  - ZTP Dashboard
  - Machines 상태 및 로그 확인

모든 UI 작업은 NABP REST API를 통해 수행됩니다.

---

### 4.2 NABP Control Plane

Control Plane은 NABP의 핵심 제어 영역입니다.

주요 기능:
- REST API 제공
- ZTP Workflow 관리
- Template 렌더링 및 실행 순서 제어
- 배포 상태(State) 및 Checkpoint 수집
- 실패 처리 및 재시도 제어

구성 요소:
- API Server
- Workflow Engine
- Template Renderer (ERB / Bash / Ansible)
- State Manager
- Metadata Database

---

## 5. Template & Workflow Architecture

NABP는 모든 배포 로직을 Template과 Workflow 구조로 관리합니다.

### 5.1 Template Types

- Partition Templates
- Provisioning Templates (Kickstart, Preseed)
- BIOS Setup Templates
- Platform Setup Templates
- Job Invocation Templates

---

### 5.2 Workflow Model

Workflow 실행 단계는 다음과 같습니다.

REGISTERING  
→ HEALTH_CHECK  
→ BIOS_SETUP  
→ OS_INSTALL  
→ PLATFORM_SETUP  
→ DEPLOYED

각 단계는 활성/비활성 설정, Timeout, Duration, Checkpoint 보고를 지원합니다.

---

## 6. Provisioning Infrastructure

### 6.1 DHCP / PXE

- Kea DHCP Proxy 사용
- Subnet 및 Proxy 설정 기반 IP 할당
- PXE Boot 지원 (pxelinux, grub, iPXE)

---

### 6.2 Media Path

Media Path는 다음 용도로 사용됩니다.

- PXE 부팅용 Kernel / Initrd 제공
- OS 설치 이미지 제공
- Health Check Live OS 다운로드

폐쇄망 환경에서는 내부 Local Repository 사용이 가능합니다.

---

## 7. Target Node Architecture

### 7.1 Diskfull Server

PXE Boot  
→ Kernel / Initrd 로딩  
→ Kickstart / Preseed 다운로드  
→ OS 이미지 설치 (Local Disk)  
→ Reboot  
→ Platform Setup

---

### 7.2 Diskless Server

PXE Boot  
→ Kernel / Initrd 로딩  
→ Initrd 수정 (tmpfs 기반 root)  
→ OS 이미지 다운로드  
→ 메모리 기반 OS 실행  
→ Platform Setup

---

## 8. ZTP Operation Flow

Admin Configuration  
→ ZTP Template 생성  
→ ZTP Dashboard 작업 생성  
→ Provisioning 시작  
→ 노드별 Workflow 실행  
→ Checkpoint 수집  
→ Completed / Failed

---

## 9. Scalability & Performance

- 수백~수천 노드 동시 배포
- 비동기 Workflow 실행
- Proxy / Worker 분산 구성
- 네트워크 대역 분리 (1G / 100G)
- Checkpoint 기반 병목 분석

---

## 10. Security & Network Assumptions

- BMC 접근 권한 필요 (IPMI / Redfish)
- PXE, DHCP, TFTP, HTTP 트래픽 허용
- Media Path 접근 가능
- 관리자 / 운영자 권한 분리 운영




