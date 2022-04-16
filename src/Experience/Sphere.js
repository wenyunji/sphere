import * as THREE from 'three'
import Experience from './Experience.js'
import vertexShader from '../Experience/shaders/vertax.glsl'
import fragmentShader from '../Experience/shaders/fragnent.glsl'
export default class Sphere {

    constructor() {

        this.experience = new Experience()
        // this.config = this.experience.config
        this.scene = this.experience.scene
        this.setGeometry()
        this.setMaterial()
        this.setMesh()
    }

    setGeometry() {
        this.geometry = new THREE.SphereGeometry(1, 32, 32)
    }

    setMaterial() {
        this.material = new THREE.ShaderMaterial({
            vertexShader:vertexShader,
            fragmentShader:fragmentShader
        })
    }

    setMesh() {
        this.mesh = new THREE.Mesh(this.geometry, this.material)
        this.scene.add(this.mesh)
    }

}